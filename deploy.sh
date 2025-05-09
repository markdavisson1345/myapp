#!/bin/bash

# Stop on errors
set -e

# Step 1: Check if we're on the main branch before proceeding
current_branch=$(git branch --show-current)
if [ "$current_branch" != "main" ]; then
    echo "Error: Please run this script from the main branch. Currently on: $current_branch"
    exit 1
fi
echo "Confirmed on the main branch."

# Step 2: Build the Flutter web app with the correct base href
echo "Building the Flutter web app with base href /myappRepo/..."
flutter build web --release --base-href="/myappRepo/"

# Step 3: Verify the build was successful
if [ ! -d "build/web" ]; then
    echo "Error: Build folder not found. Make sure the build was successful."
    exit 1
fi
echo "Build completed successfully."

# Step 4: Switch to gh-pages branch or create it if it doesn't exist
if git show-ref --verify --quiet refs/heads/gh-pages; then
    echo "Switching to existing gh-pages branch..."
    git checkout gh-pages
else
    echo "Creating new gh-pages branch..."
    git checkout -b gh-pages
fi

# Step 5: Copy the build folder from the main branch to the root of gh-pages
echo "Copying the build folder to the root of gh-pages..."
git checkout main -- build/web
mv build/web ./build

# Step 6: Move the contents of the build folder to the root
echo "Moving the contents of the build folder to the root of gh-pages..."
mv ./build/* ./

# Step 7: Remove the empty build folder
echo "Removing the empty build folder..."
rm -rf build

# Step 8: Add, commit, and push the changes
echo "Committing and pushing changes to gh-pages..."
git add .
git commit -m "Deploy updated web app to gh-pages"
git push origin gh-pages

# Step 9: Switch back to the main branch
echo "Switching back to the main branch..."
git checkout main

echo "Deployment complete! Visit: https://username.github.io/myappRepo/"
