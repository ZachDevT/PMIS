#!/bin/bash

PUBSPEC_FILE="pubspec.yaml"

if [ ! -f "$PUBSPEC_FILE" ]; then
    echo "pubspec.yaml not found!"
    exit 1
fi

# Find the version line: e.g., version: 1.0.0+1
VERSION_LINE=$(grep "^version:" $PUBSPEC_FILE)

if [ -z "$VERSION_LINE" ]; then
    echo "Version line not found in pubspec.yaml"
    exit 1
fi

# Extract the version string (e.g. 1.0.0+1)
VERSION_STRING=$(echo $VERSION_LINE | awk '{print $2}')

# Split into semantic version and build number
SEMVER=$(echo $VERSION_STRING | cut -d'+' -f1)
BUILD=$(echo $VERSION_STRING | cut -d'+' -f2)

# If no build number exists, start at 1
if [ "$SEMVER" == "$BUILD" ]; then
    BUILD=0
fi

# Split semantic version into major, minor, patch
MAJOR=$(echo $SEMVER | cut -d'.' -f1)
MINOR=$(echo $SEMVER | cut -d'.' -f2)
PATCH=$(echo $SEMVER | cut -d'.' -f3)

# Increment patch version
NEW_PATCH=$((PATCH + 1))
NEW_SEMVER="${MAJOR}.${MINOR}.${NEW_PATCH}"

# Increment the build number
NEW_BUILD=$((BUILD + 1))
NEW_VERSION_STRING="${NEW_SEMVER}+${NEW_BUILD}"

# Replace the version line in pubspec.yaml
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS sed
    sed -i '' "s/^version: .*/version: $NEW_VERSION_STRING/" $PUBSPEC_FILE
else
    # Linux sed
    sed -i "s/^version: .*/version: $NEW_VERSION_STRING/" $PUBSPEC_FILE
fi

echo "Incremented version from $VERSION_STRING to $NEW_VERSION_STRING"
