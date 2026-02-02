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

Fill data into a pre-created week file:

```bash
.claude/skills/standup-report/scripts/fill-week-report.sh 2026/week-06_jan-27-to-feb-02.md
```

The script:
1. Parses week dates from filename
2. Fetches commits from GitHub for that date range
3. Writes formatted report to the file

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
**Week:** 06 of 2026
**Period:** 2026-01-27 to 2026-02-02

---

## Summary

| stargazer | N commits |
| design | N commits |

---

## stargazer

### Features
- **feat(scope): message** - 2026-01-30

### Bug Fixes
- **fix(scope): message** - 2026-01-29

### Other
- **chore(scope): message** - 2026-01-28
```

## Manual Workflow

If scripts fail, fetch commits manually:

```bash
gh api "repos/anduintransaction/stargazer/commits?author=EMAIL&since=START&until=END" --paginate
```

Then format using the report structure above.
