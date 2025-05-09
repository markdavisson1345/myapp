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

# Step 4: Create a temporary folder to store build files
TEMP_DIR=$(mktemp -d)
echo "Temporary directory created at: $TEMP_DIR"

# Copy the entire build folder to the temporary directory
cp -r build/web/* "$TEMP_DIR/"
echo "Copied build files to temporary directory."

# Step 5: Switch to gh-pages branch or create it if it doesn't exist
if git show-ref --verify --quiet refs/heads/gh-pages; then
    echo "Switching to existing gh-pages branch..."
    git checkout gh-pages
else
    echo "Creating new gh-pages branch..."
    git checkout -b gh-pages
fi

# Step 6: Remove old files from gh-pages branch
echo "Cleaning up old files..."
git rm -rf . || true

# Step 7: Move the copied build files from the temporary directory to the root of gh-pages
echo "Moving build files to the root of gh-pages..."
mv "$TEMP_DIR"/* ./

# Step 8: Verify the contents in the root of gh-pages
echo "Files in gh-pages root:"
ls -la

# Step 9: Add, commit, and push the changes
echo "Committing and pushing changes..."
git add .
git commit -m "Deploy updated web app to gh-pages"
git push origin gh-pages

# Step 10: Switch back to the main branch
echo "Switching back to the main branch..."
git checkout main

# Clean up the temporary directory
rm -rf "$TEMP_DIR"
echo "Temporary directory cleaned up."

echo "Deployment complete! Visit: https://username.github.io/myapp/"
