#!/bin/bash

# Update README.md with the tree output
tree -a -I '.git|README.md' > README.md

# Stage all changes
git add .

# Get lists of new, modified, and deleted files (excluding README.md)
new_files=$(git ls-files --others --exclude-standard | grep -v "^README\.md$")
modified_files=$(git ls-files -m | grep -v -Ff <(git ls-files -d) | grep -v "^README\.md$")
deleted_files=$(git ls-files -d | grep -v "^README\.md$")

# Construct commit message
commit_msg=""

if [ -n "$new_files" ]; then
    commit_msg+=$'new:\n'"$new_files"$'\n\n'
fi

if [ -n "$modified_files" ]; then
    commit_msg+=$'update:\n'"$modified_files"$'\n\n'
fi

if [ -n "$deleted_files" ]; then
    commit_msg+=$'delete:\n'"$deleted_files"$'\n\n'
fi

# Remove trailing newlines
commit_msg=$(echo "$commit_msg" | sed -e :a -e '/^\s*$/d;N;ba')

# Check if there are any changes to commit (excluding README.md changes)
if [ -n "$commit_msg" ]; then
    echo "Commit message:"
    echo "=================="
    echo "$commit_msg"
    echo "=================="
    echo ""
    
    # Actually commit the changes
    git commit -m "$commit_msg"
    echo "Changes committed successfully!"
else
    # If no other changes, check if only README.md changed
    readme_changed=$(git diff --cached --name-only | grep "^README\.md$")
    if [ -n "$readme_changed" ]; then
        git commit -m "docs: update README.md with current project structure"
        echo "Only README.md updated - committed with standard message."
    else
        echo "No changes to commit."
    fi
fi

# Push all Changes
git push
