---
id:       impressions-7b2e
title:    The emission contract carries reporting, conditions, and unborn
subject:  impressions
blockers: [reporting-1a4c]
state:    closed
proof:    pass
revision: d5632f0
---
An atom finishing an operation learns from one file both what to emit and what to
report, because the two happen in the same beat. A record describing a
measurement has somewhere to say what conditions it was measured under, and a
record written before any commit exists has an honest value for its anchor that
never reads as fresh. The atoms that read those fields agree with the contract.
