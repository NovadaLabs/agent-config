# Changelog

## 3.3.0 (2026-04-12)

### Added: Journal Frontmatter, JSONL Index, Auto-Compaction

Three improvements for long-term complex projects:

**1. YAML Frontmatter on journal entries**
- New journal files now include YAML frontmatter: `date`, `project`, `tags`, `summary`
- `journal_write` accepts optional `tags` parameter: `tags: ["ui-ux", "playground"]`
- `parseFrontmatter()` / `extractTags()` / `extractSummary()` helpers for reading
- `journal_search` supports `tag` filter — skip entries that don't match

**2. Dual-format JSONL index**
- `updateJsonlIndex()` writes `index.jsonl` alongside `index.md` on every write
- Each line: `{ date, project, title, summary, tags, momentum, file }`
- Agents can scan the full index in ~100 tokens to find the right entry
- Machine-optimized: no markdown overhead, grep-friendly

**3. Auto-compaction**
- When journal entries exceed 30 (`AUTO_COMPACT_THRESHOLD`), entries older than 14 days auto-archive
- Archived files move to `journal/archive/` with full content preserved
- `archive/index.md` gets one-line summaries with tags
- Triggers automatically on `journal_write` — no manual invocation needed
- Returns `auto_compacted: N` in response when triggered

### Changed
- `journal_write` now accepts `tags` (string[]) and `palace_room` (string) parameters
- `journal_search` now accepts `tag` parameter for frontmatter-based filtering
- Version bump: 3.2.2 → 3.3.0

### Why
Session 2026-04-12 (CDANCE EU) showed that with 35+ journal entries across projects, agents can't efficiently find relevant history. The `.md` format is fine for humans but the lack of metadata (tags, summaries) makes search brute-force. These changes add a structured layer on top of the existing markdown format — no breaking changes.

## 3.2.2 and earlier

See git history.
