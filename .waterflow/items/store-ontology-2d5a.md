---
id:       store-ontology-2d5a
title:    Spent watermarks are somewhere nothing looks
subject:  store-ontology
blockers: [store-ontology-1c4f]
state:    closed
proof:    pass
revision: d9ec671
---
A watermark whose process is over moves out of the retrieval directory into a
history directory beside it. Reading the store returns only what is currently
believed, and this holds for anything that reads it rather than only for readers
that remember to skip superseded records. The files survive and stay diffable,
and a store relocated by config keeps working.
