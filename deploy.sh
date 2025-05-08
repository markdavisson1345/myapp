#!/bin/bash

# Stop on errors
set -e

# Build the Flutter web app
flutter build web --release --base-href="/myapp/"

# Check if we're on the main branch before proceeding
if [ "$(git branch --show-current)" != "main" ]; then
    echo "Error: Please run this script from the main branch."
    exit 1
fi

# Switch to gh-pages branch or create it if it doesn't exist
if git show-ref --verify --quiet refs/heads/gh-pages; then
    echo "Switching to existing gh-pages branch"
    git checkout gh-pages
else
    echo "Creating gh-pages branch"
    git checkout -b gh-pages
fi

# Remove old files from gh-pages branch
git rm -rf . || true

# Copy the contents of build/web directly to the root of gh-pages
cp -r build/web/* ./

# Add, commit, and push the changes
git add .
git commit -m "Deploy updated web app to gh-pages"
git push origin gh-pages

# Switch back to the main branch
git checkout main

echo "Deployment complete! Visit: https://username.github.io/myapp/"
