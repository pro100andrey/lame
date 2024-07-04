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
echo "calculate new checksum"
NEW_CHECKSUM=$(swift package compute-checksum $FRAMEWORK_NAME.xcframework.zip)
echo "print out new shasum for convenience reasons"
echo "New checksum is $NEW_CHECKSUM"

# 3. Replace all data from Package.swift manifest
echo "replace name module information in package manifest"
sed -E -i '' 's/let moduleName = ".+"/let moduleName = "'$FRAMEWORK_NAME\"/ Package.swift
echo "replace version information in package manifest"
sed -E -i '' 's/let version = ".+"/let version = "'$NEW_VERSION\"/ Package.swift
echo "replace checksum information in package manifest"
sed -E -i '' 's/let checksum = ".+"/let checksum = "'$NEW_CHECKSUM\"/ Package.swift

# 4. Print new content of manifest
echo "print out package manifest for convenience reasons"
cat Package.swift

# 5. Commit all data without the XCfrmework
echo "git commit all without framework and push"
git add --all -- :!$FRAMEWORK_NAME.xcframework.zip
git commit -m "New $FRAMEWORK_NAME version $NEW_VERSION"
git push

# 6. Pusblish a new release with the same version of the repository A, and attach XCFramework in the Release metadata
echo "Releasing the new version"
gh release create "$NEW_VERSION" --generate-notes "./$FRAMEWORK_NAME.xcframework.zip"

# 7. Remove zip of XCFramework
echo "delete downloaded zip file"
rm $FRAMEWORK_NAME.xcframework.zip
