#!/bin/bash
# -----------------------------------------------------------------------------
# 🚀 auto-release-fabric-d-auto.sh
# Automatically releases a new version of fabric-d with auto-incremented patch
# and optional override. Uploads source archive to GitHub release.
#
# Usage:
#   ./release-fabric-d-auto.sh v1.2.0        # Override to v1.2.0
#   ./release-fabric-d-auto.sh v2.0.0        # Bump major
#   ./release-fabric-d-auto.sh               # Auto-increment patch (e.g., v1.1.1 → v1.1.2)
#
# Prerequisites:
# - git
# - gh (GitHub CLI) installed and authenticated
# - GITHUB_TOKEN set in environment (optional, but recommended)
# -----------------------------------------------------------------------------

set -euo pipefail

# -------------------------------
# 1. CONFIGURATION
# -------------------------------
REPO_OWNER="jimscard"
REPO_NAME="fabric-d"
GITHUB_API="https://api.github.com"
REPO_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}"
DEFAULT_TAG="v1.1.1"  # ← Change this to your current baseline if needed

# -------------------------------
# 2. VERIFY DEPENDENCIES
# -------------------------------
if ! command -v git &> /dev/null; then
  echo "❌ Error: git is not installed." >&2
  exit 1
fi

if ! command -v gh &> /dev/null; then
  echo "❌ Error: gh (GitHub CLI) is not installed." >&2
  echo "Install it: https://github.com/cli/cli#installation" >&2
  exit 1
fi

# -------------------------------
# 3. GET VERSION FROM ARGUMENT OR AUTO-INCR
# -------------------------------
if [[ $# -eq 0 ]]; then
  # Auto-increment patch version
  echo "🔍 Auto-detecting latest version..."
  LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
  if [[ -z "$LATEST_TAG" ]]; then
    echo "⚠️ No tags found. Starting from $DEFAULT_TAG"
    NEW_TAG="$DEFAULT_TAG"
  else
    # Extract version parts
    IFS='.' read -r MAJOR MINOR PATCH <<< "${LATEST_TAG#v}"
    # Increment patch
    NEW_PATCH=$((PATCH + 1))
    NEW_TAG="v$MAJOR.$MINOR.$NEW_PATCH"
  fi
else
  # User override
  NEW_TAG="$1"
  if [[ ! "$NEW_TAG" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "❌ Invalid tag format. Use: v1.2.3"
    exit 1
  fi
fi

echo "🆕 New version: $NEW_TAG"

# -------------------------------
# 4. VERIFY CURRENT BRANCH & COMMIT
# -------------------------------
CURRENT_BRANCH=$(git branch --show-current)
if [[ "$CURRENT_BRANCH" != "main" ]]; then
  echo "⚠️ Warning: Not on 'main'. Switching to main..."
  git checkout main
fi

# Fetch latest
git fetch origin main

# -------------------------------
# 5. CREATE TAG (if not exists)
# -------------------------------
if git tag -l "$NEW_TAG" > /dev/null; then
  echo "⚠️ Tag $NEW_TAG already exists. Skipping."
  exit 0
fi

echo "📦 Creating tag: $NEW_TAG"
git tag -a "$NEW_TAG" -m "Release $NEW_TAG"
git push origin "$NEW_TAG"

# -------------------------------
# 6. CREATE SOURCE ARCHIVE
# -------------------------------
echo "📦 Creating source archive: fabric-d-$NEW_TAG.tar.gz"
git archive --format=tar.gz \
  --output="fabric-d-$NEW_TAG.tar.gz" \
  "$NEW_TAG"

# Verify file was created
if [[ ! -f "fabric-d-$NEW_TAG.tar.gz" ]]; then
  echo "❌ Failed to create archive." >&2
  exit 1
fi

# -------------------------------
# 7. CREATE GITHUB RELEASE
# -------------------------------
echo "📤 Creating GitHub release..."

# Use `gh release create` to upload the archive
gh release create "$NEW_TAG" \
  --title "Release $NEW_TAG" \
  --notes "Automated release from script. Includes source archive." \
  --verify-tag \
  --file "fabric-d-$NEW_TAG.tar.gz"

# ✅ Success!
echo "✅ Release $NEW_TAG created successfully!"
echo "🔗 Release URL: $REPO_URL/releases/tag/$NEW_TAG"
echo "📁 Archive: fabric-d-$NEW_TAG.tar.gz"
