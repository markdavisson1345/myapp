#!/bin/bash

# Build the web app
flutter build web --release --base-href="/myapp/"

# Check if gh-pages branch exists locally
if git show-ref --verify --quiet refs/heads/gh-pages; then
    echo "Switching to existing gh-pages branch"
    git checkout gh-pages
else
    echo "Creating gh-pages branch"
    git checkout -b gh-pages
fi

# Remove old files
git rm -rf .

# Copy new build files
cp -r ../build/web/* ./

# Add changes
git add .
git commit -m "Deploy updated web app to gh-pages"

# Push to the remote gh-pages branch
git push --set-upstream origin gh-pages

# Switch back to main branch
git checkout main

echo "Deployment complete! Visit: https://username.github.io/myapp/"
