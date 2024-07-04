#!/bin/sh

# Check for arguments
if [ $# -eq 0 ]; then
    echo "No arguments provided. First argument has to be version, e.g. '1.8.1'"
    exit 1
fi

# 1. Get params
NEW_VERSION=$1
FRAMEWORK_NAME=$2

# 2. Calculate checksum and store it
if [ ! -f "$FRAMEWORK_NAME.xcframework.zip" ]; then
    echo "File not found at path: $FRAMEWORK_NAME.xcframework.zip"
    exit 1
fi

echo "Calculate new checksum"
NEW_CHECKSUM=$(swift package compute-checksum $FRAMEWORK_NAME.xcframework.zip)
echo "Print out new checksum for convenience reasons"
echo "New checksum is $NEW_CHECKSUM"

# 3. Replace all data from Package.swift manifest
echo "Replace version information in package manifest"
sed -E -i '' 's|(url: "https://github.com/pro100andrey/lame/releases/download/).+('"$FRAMEWORK_NAME.xcframework.zip"')|\1'"$NEW_VERSION"'/\2|' Package.swift

echo "Replace checksum information in package manifest"
sed -E -i '' 's|(checksum: ").+(")|\1'"$NEW_CHECKSUM"'\2|' Package.swift

# 4. Print new content of manifest
echo "Print out package manifest for convenience reasons"
cat Package.swift

# 5. Commit all data without the XCframework
echo "Git commit all without framework and push"
git add --all -- :!"$FRAMEWORK_NAME.xcframework.zip"
git commit -m "New $FRAMEWORK_NAME version $NEW_VERSION"
git push

# 6. Publish a new release with the same version of the repository, and attach XCFramework in the Release metadata
echo "Releasing the new version"
gh release create "$NEW_VERSION" --generate-notes "./$FRAMEWORK_NAME.xcframework.zip"

# 7. Remove zip of XCFramework
echo "Delete downloaded zip file"
rm "$FRAMEWORK_NAME.xcframework.zip"
