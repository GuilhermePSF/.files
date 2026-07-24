#!/bin/sh

# This script regenerates the repository structure tree in the documentation.
# It should be run whenever files or directories are added, removed, or renamed.

# Define the target file
TARGET_FILE="docs/DAILY_USE.md"

# Find the line number of the "Repository Structure" heading
HEADING_LINE=$(grep -n "## Repository Structure" "$TARGET_FILE" | cut -d: -f1)

# If the heading exists, trim the file to just before it
if [ -n "$HEADING_LINE" ]; then
  # Subtract 1 from the heading line to keep the line above it
  TRIM_LINE=$((HEADING_LINE - 1))
  head -n "$TRIM_LINE" "$TARGET_FILE" > "$TARGET_FILE.tmp" && mv "$TARGET_FILE.tmp" "$TARGET_FILE"
fi

# Append the heading and the new tree to the file
cat >> "$TARGET_FILE" << 'EOF'

## Repository Structure

This provides an overview of the configuration's layout.

EOF

# Append the repository structure tree
echo '```' >> "$TARGET_FILE"
tree -a -I '.git|result' >> "$TARGET_FILE"
echo '```' >> "$TARGET_FILE"

echo "Repository structure in $TARGET_FILE has been updated."
