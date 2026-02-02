---
name: standup-report
description: Generate weekly engineering standup reports from GitHub commits. Use when user asks to "generate standup", "weekly report", "my commits this week", "fill in week report", "engineering contributions", or wants a summary of work across anduintransaction/stargazer and anduintransaction/design repositories. Also triggers when working with 2026/ weekly report files.
---

# Standup Report

Generate weekly engineering contribution reports from GitHub repositories.

## Project Structure

```
2026/
├── week-01_dec-29-to-jan-04.md
├── week-02_jan-05-to-jan-11.md
...
└── week-53_dec-28-to-jan-03.md
```

## Fill Existing Week Report

```bash
.claude/skills/standup-report/scripts/fill-week-report.sh 2026/week-06_jan-27-to-feb-02.md
```

## Generate New Report (Current Week)

```bash
.claude/skills/standup-report/scripts/fetch-weekly-commits.sh [output_dir]
```

## Configuration

Repositories:
- `anduintransaction/stargazer`
- `anduintransaction/design`

Author: detected from `git config user.email` or `GIT_AUTHOR_EMAIL` env var.

## Report Format

```markdown
# Weekly Standup Report

**Author:** name (email)
**Week:** 05 of 2026
**Period:** 2026-01-26 to 2026-02-01

---

## Summary

| Repository | Commits |
|------------|---------|
| stargazer  | 17      |
| design     | 9       |

---

## Completed

- Implemented stale-while-revalidate data fetching pattern for better UX
- Added code-reviewer agent for automated PR reviews
- Fixed TabMinimalL component sizing issues across stargazer and design
- Improved Claude Code skills: claude-md-improver, scala-coding-styles

---

## Commits

### stargazer
- bump acl to latest
- add code-reviewer agent and improve frontend patterns
- stale-while-revalidate data fetching pattern
- store semanticHTML from RichEditor for email sending

### design
- Add distinct to Screen breakpoint signals
- use grow instead of flexGrow
- TabMinimalL: avoid flex-basis: 0
```

The **Completed** section is a high-level summary of contributions (to be written manually or by Claude). The **Commits** section lists all raw commits.
