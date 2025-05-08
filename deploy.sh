#!/bin/bash

# Stop on errors
set -e

# Step 1: Build the Flutter web app
echo "Building the Flutter web app..."
flutter build web --release --base-href="/myapp/"

# Step 2: Verify the build was successful
if [ ! -d "build/web" ]; then
    echo "Error: Build folder not found. Make sure the build was successful."
    exit 1
fi
echo "Build completed successfully."

# Step 3: Check if we're on the main branch before proceeding
current_branch=$(git branch --show-current)
if [ "$current_branch" != "main" ]; then
    echo "Error: Please run this script from the main branch. Currently on: $current_branch"
    exit 1
fi
echo "Confirmed on the main branch."

# Step 4: Switch to gh-pages branch or create it if it doesn't exist
if git show-ref --verify --quiet refs/heads/gh-pages; then
    echo "Switching to existing gh-pages branch..."
    git checkout gh-pages
else
    echo "Creating new gh-pages branch..."
    git checkout -b gh-pages
fi

# Step 5: Remove old files from gh-pages branch
echo "Cleaning up old files..."
git rm -rf . || true

# Step 6: Copy new build files to the root of gh-pages branch
echo "Copying new build files to gh-pages..."
cp -r build/web/* ./

# Step 7: Add, commit, and push the changes
echo "Committing and pushing changes..."
git add .
git commit -m "Deploy updated web app to gh-pages"
git push origin gh-pages

# Step 8: Switch back to the main branch
echo "Switching back to the main branch..."
git checkout main

echo "Deployment complete! Visit: https://username.github.io/myapp/"
