#!/bin/bash
# -----------------------------------------------------------------------------
# 🚀 auto-release-fabric-d-auto.sh (Fixed)
# Automatically releases a new version of fabric-d with auto-incremented patch
# and optional override. Creates release even if tag exists.
# Now includes proper tag fetch.
# -----------------------------------------------------------------------------

set -euo pipefail

# -------------------------------
# 1. CONFIGURATION
# -------------------------------
REPO_OWNER="jimscard"
REPO_NAME="fabric-d"
GITHUB_API="https://api.github.com"
REPO_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}"
DEFAULT_TAG="v1.1.1"

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
  echo "🔍 Auto-detecting latest version..."
  LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
  if [[ -z "$LATEST_TAG" ]]; then
    echo "⚠️ No tags found. Starting from $DEFAULT_TAG"
    NEW_TAG="$DEFAULT_TAG"
  else
    IFS='.' read -r MAJOR MINOR PATCH <<< "${LATEST_TAG#v}"
    NEW_PATCH=$((PATCH + 1))
    NEW_TAG="v$MAJOR.$MINOR.$NEW_PATCH"
  fi
else
  # Trim leading and trailing whitespace from the input
  NEW_TAG="$(echo "$1" | xargs)"
  if [[ ! "$NEW_TAG" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "❌ Invalid tag format. Use: v1.2.3"
    exit 1
  fi
fi

echo "🆕 New version: $NEW_TAG"

# -------------------------------
# 4. VERIFY CURRENT BRANCH & FETCH TAGS
# -------------------------------
CURRENT_BRANCH=$(git branch --show-current)
if [[ "$CURRENT_BRANCH" != "main" ]]; then
  echo "⚠️ Warning: Not on 'main'. Switching to main..."
  git checkout main
fi

# Fetch remote tags
echo "📥 Fetching remote tags..."
git fetch origin main --tags

# -------------------------------
# 5. CREATE TAG (if not exists)
# -------------------------------
if git tag -l "$NEW_TAG" | grep -q "$NEW_TAG"; then
  echo "⚠️ Tag $NEW_TAG already exists. Proceeding to create release..."
else
  echo "📦 Creating tag: $NEW_TAG"
  git tag -a "$NEW_TAG" -m "Release $NEW_TAG"
  git push origin "$NEW_TAG"
fi

# -------------------------------
# 6. CREATE SOURCE ARCHIVE
# -------------------------------
# Verify tag exists locally. If not, fetch from the remote repository.
if ! git rev-parse --verify "$NEW_TAG" >/dev/null 2>&1; then
  echo "⚠️ Tag $NEW_TAG not found locally. Attempting to fetch tags from origin..."
  git fetch origin --tags

  # Double-check if the tag exists
  if ! git rev-parse --verify "$NEW_TAG" >/dev/null 2>&1; then
    echo "❌ Tag $NEW_TAG does not exist remotely either. Aborting release."
    exit 1
  fi
fi

echo "📦 Creating source archive: fabric-d-$NEW_TAG.tar.gz"
git archive --format=tar.gz \
  --output="fabric-d-$NEW_TAG.tar.gz" \
  "$NEW_TAG"

if [[ ! -f "fabric-d-$NEW_TAG.tar.gz" ]]; then
  echo "❌ Failed to create archive." >&2
  exit 1
fi

# -------------------------------
# 7. CREATE GITHUB RELEASE
# -------------------------------
echo "📤 Creating GitHub release..."

gh release create "$NEW_TAG" \
  --title "Release $NEW_TAG" \
  --notes "Automated release from script. Includes source archive." \
  --verify-tag \
  "fabric-d-$NEW_TAG.tar.gz"

echo "✅ Release $NEW_TAG created successfully!"
echo "🔗 Release URL: $REPO_URL/releases/tag/$NEW_TAG"
echo "📁 Archive: fabric-d-$NEW_TAG.tar.gz"
