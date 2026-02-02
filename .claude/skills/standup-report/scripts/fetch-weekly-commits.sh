#!/bin/bash
# Fetch weekly commits from configured GitHub repos and generate a markdown report
# Usage: ./fetch-weekly-commits.sh [output_dir]
# Fetches commits from the past 7 days ending today

set -e

# Configuration
REPOS=("anduintransaction/stargazer" "anduintransaction/design")
AUTHOR_EMAIL="${GIT_AUTHOR_EMAIL:-$(git config user.email)}"
OUTPUT_DIR="${1:-.}"

# Calculate dates - past 7 days ending today
WEEK_NUM=$(date +%V)
YEAR=$(date +%Y)
WEEK_END=$(date +%Y-%m-%d)
WEEK_START=$(date -v-6d +%Y-%m-%d)
SINCE_DATE=$(date -v-6d +%Y-%m-%dT00:00:00Z)

# Output filename: week-05_jan-27-to-feb-02_2026.md
START_DAY=$(date -v-6d +%d)
END_DAY=$(date +%d)
START_MONTH=$(date -v-6d +%b | tr '[:upper:]' '[:lower:]')
END_MONTH=$(date +%b | tr '[:upper:]' '[:lower:]')
OUTPUT_FILE="${OUTPUT_DIR}/week-${WEEK_NUM}_${START_MONTH}-${START_DAY}-to-${END_MONTH}-${END_DAY}_${YEAR}.md"

echo "Fetching commits for: $AUTHOR_EMAIL"
echo "Week $WEEK_NUM: $WEEK_START to $WEEK_END"
echo "Output: $OUTPUT_FILE"

# Temporary file for collecting commits
TEMP_FILE=$(mktemp)

# Fetch commits from each repo
for REPO in "${REPOS[@]}"; do
    echo "Fetching from $REPO..."
    gh api "repos/${REPO}/commits?author=${AUTHOR_EMAIL}&since=${SINCE_DATE}" --paginate 2>/dev/null | \
    jq -r --arg repo "$REPO" '.[] | "\($repo)|\(.commit.author.date)|\(.commit.message | split("\n")[0])|\(.html_url)"' >> "$TEMP_FILE" || true
done

# Generate markdown report
cat > "$OUTPUT_FILE" << EOF
# Weekly Standup Report

**Author:** $(git config user.name) ($(git config user.email))
**Week:** $WEEK_NUM of $YEAR
**Period:** $WEEK_START to $WEEK_END

---

## Summary

EOF

# Count commits per repo
for REPO in "${REPOS[@]}"; do
    COUNT=$(grep "^${REPO}|" "$TEMP_FILE" | wc -l | tr -d ' ')
    REPO_NAME=$(echo "$REPO" | cut -d'/' -f2)
    echo "| $REPO_NAME | $COUNT commits |" >> "$OUTPUT_FILE"
done

echo "" >> "$OUTPUT_FILE"
echo "---" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Group commits by repo
for REPO in "${REPOS[@]}"; do
    REPO_NAME=$(echo "$REPO" | cut -d'/' -f2)
    REPO_COMMITS=$(grep "^${REPO}|" "$TEMP_FILE" || true)

    if [ -n "$REPO_COMMITS" ]; then
        echo "## $REPO_NAME" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"

        # Categorize commits
        FEATS=$(echo "$REPO_COMMITS" | grep -i "|feat" || true)
        if [ -n "$FEATS" ]; then
            echo "### Features" >> "$OUTPUT_FILE"
            echo "$FEATS" | while IFS='|' read -r _ date msg url; do
                DAY=$(echo "$date" | cut -dT -f1)
                echo "- **${msg}** - ${DAY}" >> "$OUTPUT_FILE"
            done
            echo "" >> "$OUTPUT_FILE"
        fi

        FIXES=$(echo "$REPO_COMMITS" | grep -i "|fix" || true)
        if [ -n "$FIXES" ]; then
            echo "### Bug Fixes" >> "$OUTPUT_FILE"
            echo "$FIXES" | while IFS='|' read -r _ date msg url; do
                DAY=$(echo "$date" | cut -dT -f1)
                echo "- **${msg}** - ${DAY}" >> "$OUTPUT_FILE"
            done
            echo "" >> "$OUTPUT_FILE"
        fi

        OTHERS=$(echo "$REPO_COMMITS" | grep -iv "|feat" | grep -iv "|fix" || true)
        if [ -n "$OTHERS" ]; then
            echo "### Other" >> "$OUTPUT_FILE"
            echo "$OTHERS" | while IFS='|' read -r _ date msg url; do
                DAY=$(echo "$date" | cut -dT -f1)
                echo "- **${msg}** - ${DAY}" >> "$OUTPUT_FILE"
            done
            echo "" >> "$OUTPUT_FILE"
        fi

        echo "---" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
    fi
done

# Cleanup
rm -f "$TEMP_FILE"

echo "Report generated: $OUTPUT_FILE"
