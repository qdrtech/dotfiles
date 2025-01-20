#!/bin/bash

# Fetch the latest changes from the remote, pruning branches that were removed
git fetch --prune

# Get a list of local branches that are not present on the remote
stale_branches=$(git branch -vv | awk '/: gone]/{print $1}')

if [ -z "$stale_branches" ]; then
  echo "No stale branches to delete."
  exit 0
fi

# Display the branches that will be deleted
echo "The following stale branches will be deleted:"
echo "$stale_branches"

# Confirm deletion
read -p "Are you sure you want to delete these branches? [y/N] " confirm
if [[ $confirm =~ ^[Yy]$ ]]; then
  # Delete the stale branches
  echo "$stale_branches" | xargs git branch -d
  echo "Stale branches deleted."
else
  echo "Operation canceled."
  exit 0
fi
