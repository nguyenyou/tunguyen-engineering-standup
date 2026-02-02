# Weekly Standup Report

**Author:** nguyenyou (tunt081295@gmail.com)
**Week:** 01 of 2026
**Period:** 2025-12-29 to 2026-01-04

---

## Summary

| Repository | Commits |
|------------|---------|
| stargazer | 23 |
| design | 8 |

---

## Completed

<!-- TODO: Write high-level summary of contributions -->

---

## Commits

### stargazer
- platform(web): frontend devtools v3
- fix(TextBoxL): avoid dom mutation due to clear button re-create
- fix(ocr-table): avoid unwanted dom mutation - table search toolbar
- fix(ocr-table): avoid unwanted dom mutation
- web(devtools): dom stats
- feat(ocr-table): renderHighlightedSubtext
- fix(ocr-table): format code
- feat(ocr-table): highlight whole field in search mode
- refactor(ocr-table): search match highlight
- refactor(ocr-table): searchResult
- feat(ocr-table): highlight section label
- refactor(ocr-table): improve lazySearchMatch signature
- refactor(ocr-table): improve naming
- frontend-devtools: align center memory usage
- frontend-devtools: delay show tooltip
- frontend-devtools: support reactjs, better tooltip position, defensive code
- fix(memory-leak): DataExtract
- platform(web): frontend devtools v2 - enable/disable API
- platform(web): frontend devtools v2
- fix(ocr-table): prevent CompoundFieldValue re-renders on unrelated search jumps
- feat(ocr-table): consolidate field label + field value as one search entry (#50596)
- optimize(ocr-table): favor onVisibilityChangedL over VisibilityTrackerL
- optimize(ocr-table): favor combineWithFn over combineWith + map

### design
- fix(TextBoxL): use def instead lazy val because this is a small component can be rendered fast
- fix(TextBoxL): oneline tw
- fix(TextBoxL): create once when needed and reuse
- fix(TextBoxL): avoid unnecessary dom mutation for clear button
- docs: add frontend-devtools
- fix(memory-leak): MentaionL, ViewerInnerR, DrawingBoardR
- fix(memory-leak): ContextMenuL & ViewerInnerL
- feat(acl4): add brush icons

