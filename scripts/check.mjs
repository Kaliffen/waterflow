#!/usr/bin/env node
// Waterflow repo validation. Zero dependencies. Run: node scripts/check.mjs
//
// Checks. Cheap and deterministic only: nothing here asks a model anything.
//   1. every skill directory has a SKILL.md
//   2. frontmatter keys are in the known set, and name matches the directory
//   3. relative markdown links resolve on disk
//   4. .claude-plugin/plugin.json lists exactly the skills on disk
//   5. no file carries a UTF-8 BOM or a stray control character
//   6. model-invoked skill count stays within the description budget

import { readFileSync, readdirSync, statSync, existsSync } from "node:fs";
import { join, dirname, resolve, relative, sep } from "node:path";
import { fileURLToPath } from "node:url";

const ROOT = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const SKILLS_DIR = join(ROOT, "skills");
const MANIFEST = join(ROOT, ".claude-plugin", "plugin.json");
const DESCRIPTION_BUDGET = 11;

const KNOWN_FRONTMATTER_KEYS = new Set([
  "name",
  "description",
  "argument-hint",
  "disable-model-invocation",
  "allowed-tools",
  "source",
]);

const SKIP_DIRS = new Set([".git", ".review", "node_modules", ".idea"]);

const errors = [];
const fail = (m) => errors.push(m);
const rel = (p) => relative(ROOT, p).split(sep).join("/");

function walk(dir, out = []) {
  for (const entry of readdirSync(dir)) {
    if (SKIP_DIRS.has(entry)) continue;
    const full = join(dir, entry);
    if (statSync(full).isDirectory()) walk(full, out);
    else out.push(full);
  }
  return out;
}

// Minimal YAML-ish frontmatter reader. Sufficient for the flat key: value
// frontmatter skills use; deliberately not a YAML parser.
function readFrontmatter(text) {
  if (!text.startsWith("---")) return null;
  const end = text.indexOf("\n---", 3);
  if (end === -1) return null;
  const body = text.slice(4, end);
  const out = {};
  for (const line of body.split("\n")) {
    if (!line.trim() || line.startsWith("#") || /^\s/.test(line)) continue;
    const idx = line.indexOf(":");
    if (idx === -1) continue;
    out[line.slice(0, idx).trim()] = line.slice(idx + 1).trim();
  }
  return out;
}

// --- 5. BOMs and control characters ------------------------------------------
// A stray control character is invisible in every editor and survives review.
// Tab, newline and carriage return are the only ones text here may contain.
const CONTROL = /[\x00-\x08\x0b\x0c\x0e-\x1f]/;
const allFiles = walk(ROOT);
for (const f of allFiles) {
  const buf = readFileSync(f);
  if (buf[0] === 0xef && buf[1] === 0xbb && buf[2] === 0xbf) {
    fail(`BOM: ${rel(f)} starts with a UTF-8 BOM`);
  }
  const text = buf.toString("utf8");
  const lines = text.split("\n");
  for (let i = 0; i < lines.length; i++) {
    const m = CONTROL.exec(lines[i]);
    if (m) {
      const code = "0x" + m[0].charCodeAt(0).toString(16).padStart(2, "0");
      fail(`control: ${rel(f)}:${i + 1} contains ${code}`);
      break;
    }
  }
}

// --- 1, 2. skills and frontmatter -------------------------------------------
const skillNames = [];
let modelInvoked = 0;

if (!existsSync(SKILLS_DIR)) {
  fail("layout: skills/ does not exist");
} else {
  for (const entry of readdirSync(SKILLS_DIR)) {
    const skillDir = join(SKILLS_DIR, entry);
    if (!statSync(skillDir).isDirectory()) continue;
    skillNames.push(entry);

    const skillMd = join(skillDir, "SKILL.md");
    if (!existsSync(skillMd)) {
      fail(`skill: ${entry} has no SKILL.md`);
      continue;
    }

    const text = readFileSync(skillMd, "utf8");
    const fm = readFrontmatter(text);
    if (!fm) {
      fail(`frontmatter: ${rel(skillMd)} has no frontmatter block`);
      continue;
    }

    for (const key of Object.keys(fm)) {
      if (!KNOWN_FRONTMATTER_KEYS.has(key)) {
        fail(
          `frontmatter: ${rel(skillMd)} has unknown key "${key}" ` +
            `(known: ${[...KNOWN_FRONTMATTER_KEYS].join(", ")})`,
        );
      }
    }
    if (!fm.name) fail(`frontmatter: ${rel(skillMd)} has no name`);
    else if (fm.name !== entry) {
      fail(`frontmatter: ${rel(skillMd)} name "${fm.name}" != directory "${entry}"`);
    }
    if (!fm.description) fail(`frontmatter: ${rel(skillMd)} has no description`);

    if (fm["disable-model-invocation"] !== "true") modelInvoked++;
  }
}

// --- 6. description budget ---------------------------------------------------
if (modelInvoked > DESCRIPTION_BUDGET) {
  fail(
    `budget: ${modelInvoked} model-invoked skills exceeds the budget of ` +
      `${DESCRIPTION_BUDGET}. A new one must displace an existing one.`,
  );
}

// --- 3. relative links -------------------------------------------------------
const LINK = /\[[^\]]*\]\(([^)]+)\)/g;
for (const f of allFiles.filter((f) => f.endsWith(".md"))) {
  const text = readFileSync(f, "utf8");
  for (const [, target] of text.matchAll(LINK)) {
    if (/^(https?:|mailto:|#)/.test(target)) continue;
    const clean = target.split("#")[0].trim();
    if (!clean) continue;
    if (!existsSync(resolve(dirname(f), clean))) {
      fail(`link: ${rel(f)} points at missing ${clean}`);
    }
  }
}

// --- 4. manifest sync --------------------------------------------------------
if (!existsSync(MANIFEST)) {
  fail("manifest: .claude-plugin/plugin.json does not exist");
} else {
  let manifest;
  try {
    manifest = JSON.parse(readFileSync(MANIFEST, "utf8"));
  } catch (e) {
    fail(`manifest: .claude-plugin/plugin.json is not valid JSON (${e.message})`);
  }
  if (manifest) {
    if (!Array.isArray(manifest.skills)) {
      fail('manifest: "skills" must be an array of skill paths');
    } else {
      const listed = manifest.skills.map((p) => p.replace(/^\.\/skills\//, ""));
      for (const name of skillNames) {
        if (!listed.includes(name)) fail(`manifest: ${name} exists on disk but is not listed`);
      }
      for (const name of listed) {
        if (!skillNames.includes(name)) fail(`manifest: lists ${name}, which is not on disk`);
      }
    }
  }
}

// --- report ------------------------------------------------------------------
for (const e of errors) console.error(`FAIL  ${e}`);

if (errors.length) {
  console.error(`\n${errors.length} problem(s).`);
  process.exit(1);
}
console.log(
  `ok  ${skillNames.length} skill(s), ${modelInvoked}/${DESCRIPTION_BUDGET} model-invoked, ` +
    `${allFiles.length} files checked.`,
);
