#!/bin/bash
# Fill in an existing weekly report file with commit data
# Usage: ./fill-week-report.sh <week-file>
# Example: ./fill-week-report.sh 2026/week-06_jan-27-to-feb-02.md

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <week-file>"
    echo "Example: $0 2026/week-06_jan-27-to-feb-02.md"
    exit 1
fi

WEEK_FILE="$1"
if [ ! -f "$WEEK_FILE" ]; then
    echo "Error: File not found: $WEEK_FILE"
    exit 1
fi

# Configuration
REPOS=("anduintransaction/stargazer" "anduintransaction/design")
AUTHOR_EMAIL="${GIT_AUTHOR_EMAIL:-$(git config user.email)}"

# Parse dates from filename: week-06_jan-27-to-feb-02.md
BASENAME=$(basename "$WEEK_FILE" .md)
WEEK_NUM=$(echo "$BASENAME" | sed 's/week-\([0-9]*\)_.*/\1/')

# Extract start/end from filename
START_PART=$(echo "$BASENAME" | sed 's/week-[0-9]*_\(.*\)-to-.*/\1/')
END_PART=$(echo "$BASENAME" | sed 's/.*-to-\(.*\)/\1/')

START_MONTH=$(echo "$START_PART" | cut -d'-' -f1)
START_DAY=$(echo "$START_PART" | cut -d'-' -f2)
END_MONTH=$(echo "$END_PART" | cut -d'-' -f1)
END_DAY=$(echo "$END_PART" | cut -d'-' -f2)

# Determine year from directory
YEAR=$(dirname "$WEEK_FILE" | grep -oE '[0-9]{4}' | tail -1)
[ -z "$YEAR" ] && YEAR=$(date +%Y)

# Convert month abbreviations to numbers
month_to_num() {
    case $(echo "$1" | tr '[:upper:]' '[:lower:]') in
        jan) echo "01" ;; feb) echo "02" ;; mar) echo "03" ;;
        apr) echo "04" ;; may) echo "05" ;; jun) echo "06" ;;
        jul) echo "07" ;; aug) echo "08" ;; sep) echo "09" ;;
        oct) echo "10" ;; nov) echo "11" ;; dec) echo "12" ;;
    esac
}

START_MONTH_NUM=$(month_to_num "$START_MONTH")
END_MONTH_NUM=$(month_to_num "$END_MONTH")

# Handle year boundary (dec to jan)
START_YEAR=$YEAR
END_YEAR=$YEAR
if [ "$START_MONTH_NUM" = "12" ] && [ "$END_MONTH_NUM" = "01" ]; then
    START_YEAR=$((YEAR - 1))
fi
if [ "$START_MONTH_NUM" = "12" ] && [ "$WEEK_NUM" = "01" ]; then
    START_YEAR=$((YEAR - 1))
fi

WEEK_START="${START_YEAR}-${START_MONTH_NUM}-${START_DAY}"
WEEK_END="${END_YEAR}-${END_MONTH_NUM}-${END_DAY}"
SINCE_DATE="${WEEK_START}T00:00:00Z"
UNTIL_DATE="${WEEK_END}T23:59:59Z"

echo "Filling report: $WEEK_FILE"
echo "Author: $AUTHOR_EMAIL"
echo "Period: $WEEK_START to $WEEK_END"

# Temporary file for collecting commits
TEMP_FILE=$(mktemp)

# Fetch commits from each repo
for REPO in "${REPOS[@]}"; do
    echo "Fetching from $REPO..."
    gh api "repos/${REPO}/commits?author=${AUTHOR_EMAIL}&since=${SINCE_DATE}&until=${UNTIL_DATE}" --paginate 2>/dev/null | \
    jq -r --arg repo "$REPO" '.[] | "\($repo)|\(.commit.message | split("\n")[0])"' >> "$TEMP_FILE" || true
done

# Generate markdown report
cat > "$WEEK_FILE" << EOF
# Weekly Standup Report

**Author:** $(git config user.name) ($(git config user.email))
**Week:** $WEEK_NUM of $YEAR
**Period:** $WEEK_START to $WEEK_END

---

## Summary

| Repository | Commits |
|------------|---------|
EOF

# Count commits per repo
for REPO in "${REPOS[@]}"; do
    COUNT=$(grep "^${REPO}|" "$TEMP_FILE" | wc -l | tr -d ' ')
    REPO_NAME=$(echo "$REPO" | cut -d'/' -f2)
    echo "| $REPO_NAME | $COUNT |" >> "$WEEK_FILE"
done

cat >> "$WEEK_FILE" << EOF

---

## Completed

<!-- TODO: Write high-level summary of contributions -->

---

## Commits

EOF

# Group commits by repo under Commits section
for REPO in "${REPOS[@]}"; do
    REPO_NAME=$(echo "$REPO" | cut -d'/' -f2)
    REPO_COMMITS=$(grep "^${REPO}|" "$TEMP_FILE" || true)

    if [ -n "$REPO_COMMITS" ]; then
        echo "### $REPO_NAME" >> "$WEEK_FILE"
        echo "$REPO_COMMITS" | while IFS='|' read -r _ msg; do
            echo "- $msg" >> "$WEEK_FILE"
        done
        echo "" >> "$WEEK_FILE"
    fi
done

# Cleanup
rm -f "$TEMP_FILE"

TOTAL=$(wc -l < "$WEEK_FILE" | tr -d ' ')
echo "Done. Report has $TOTAL lines."
