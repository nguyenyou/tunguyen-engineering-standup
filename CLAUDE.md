# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Weekly engineering standup report generator that fetches commits from GitHub repositories and generates markdown reports organized by ISO week number.

## Commands

Fill an existing week report with commit data:
```bash
.claude/skills/standup-report/scripts/fill-week-report.sh 2026/week-05_jan-26-to-feb-01.md
```

Generate report for current week:
```bash
.claude/skills/standup-report/scripts/fetch-weekly-commits.sh [output_dir]
```

## Configuration

Tracked repositories (hardcoded in scripts):
- anduintransaction/stargazer
- anduintransaction/design

Author detection: `git config user.email` or `GIT_AUTHOR_EMAIL` env var.

## Report Structure

Each weekly report contains:
1. Summary - commit counts per repository
2. Completed - high-level summary (written manually or by Claude based on commits)
3. Commits - raw commit messages grouped by repository

## File Naming Convention

`week-{ISO_WEEK}_{start_month}-{start_day}-to-{end_month}-{end_day}.md`

Example: `week-05_jan-26-to-feb-01.md`

## Writing the Completed Section

When asked to fill the Completed section:
- Keep it short (5-8 bullet points max)
- Group related commits by theme
- No markdown formatting (no ** or `)
- Prefer brevity over completeness
