#!/bin/bash

minVersionIos="12.0"
minVersionTvOS="12.0"
minVersionMacOS="10.14"
bundleVersion="1.2.5"

# Function for logging info with a timestamp
log() {
	local message="$1" # Message to be logged

	# Formatting current date and time
	local timestamp=$(date +"%Y-%m-%d %H:%M:%S")

	# Green color
	local green='\033[1;32m'
	# Reset color
	local reset='\033[0m'

	# Output the step log in the format: [Date and time] Step: Step name
	echo -e "${green}[$timestamp]${reset}: $message"
}

# Function for logging details without a timestamp
info() {
	local message="$1" # Message to be logged

	# Formatting current date and time
	local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
	# Green color
	local green='\033[1;32m'
	# Yellow color
	local yellow='\033[1;33m'
	# Reset color
	local reset='\033[0m'

	# Output the log message in the format: [Date and time] Message
	echo -e "${green}[$timestamp]${reset}: ${yellow}$message${reset}"
}

# Initialize global variables
initialize_global_variables() {
	log "Initializing global variables"

	# Set the version of LAME to be used
	local lame_version="3.100"

	LAME_FILE="lame-$lame_version.tar.gz"
	LAME_DIR="lame-$lame_version"
	SOURCE=$LAME_DIR
	FAT=".fat-lame"
	SCRATCH=".scratch-lame"
	THIN="$(pwd)/.thin-lame"

	CONFIGURE_FLAGS="--disable-shared --disable-frontend --disable-debug --disable-dependency-tracking"
}

# Remove previous LAME build
remove_lame() {
	log "Removing previous LAME"

	rm -rf $LAME_DIR
}

# Download LAME if not present
download_lame() {
	log "Downloading LAME"

	if ! [ -f $LAME_FILE ]; then
		echo "downloading $LAME_FILE ..."
		curl -o $LAME_FILE https://altushost-swe.dl.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz?viasf=1
		if [ $? != 0 ]; then
			echo "downloading $LAME_FILE error ..."
			exit -1
		else
			echo "downloading $LAME_FILE done ..."
		fi
	fi

	# Verify file integrity
	file_type=$(file -b --mime-type $LAME_FILE)
	if [ "$file_type" != "application/gzip" ]; then
		echo "Error: $LAME_FILE is not a valid gzip file."
		rm -f $LAME_FILE
		exit 1
	fi
}

# Extract LAME tarball
extract_lame_tarball() {
	log "Extracting tarball"

	if ! tar xf "$LAME_FILE"; then
		echo "Error extracting $LAME_FILE"
		rm -rf "$LAME_FILE" "$LAME_DIR"
		exit 1
	fi
}

# Compile function for Mac Catalyst
compile_mac_catalyst() {
	local cwd=$(pwd) # Current working directory
	local arch=$1 # Architecture
	local host=$2 # Host
	local platform=$3 # Platform
	local target="-target ${arch}-apple-ios14.0-macabi" # Target for Mac Catalyst

	info "Compiling for $arch"

	# Setup environment variables for compilation
	local sdk=$(echo $platform | tr '[:upper:]' '[:lower:]')
	local cc="xcrun -sdk $sdk clang -arch $arch"
	local cflag="$target"
	local cxxflags="$cflag"
	local ldflags="$cflag"

	# Create scratch directory and move to it
	mkdir -p "$SCRATCH/$arch"
	cd "$SCRATCH/$arch"

	# Configure and compile
	CC=$cc $cwd/$SOURCE/configure \
		$CONFIGURE_FLAGS \
		--host=$host \
		--prefix="$THIN/$arch" \
		CC="$cc" CFLAGS="$cflag" LDFLAGS="$ldflags"

	# Install the compiled files
	make -j3 -s install

	# Return to the previous directory
	cd $cwd
}





# Generic compile function
# $1-arch $2-host $3- platform
compile() {
	local cwd=$(pwd) # Current working directory
	local arch=$1 # Architecture
	local host=$2 # Host
	local platform=$3 # Platform

	info "Compiling for $arch"

	# Determine deployment target based on platform
	min_os_version=""
	deployment_target=""

	if [ $platform == "iPhoneOS" ]; then
		deployment_target=$minVersionIos
	elif [ $platform == "iPhoneSimulator" ]; then
		deployment_target=$minVersionIos
	elif [ $platform == "AppleTVOS" ]; then
		deployment_target=$minVersionTvOS
	elif [ $platform == "AppleTVSimulator" ]; then
		deployment_target=$minVersionTvOS
	elif [ $platform == "MacOSX" ]; then
		deployment_target=$minVersionMacOS
	else
		min_os_version=""
	fi

	# Set minimum OS version flag
	if [ $platform == "iPhoneOS" ]; then
		min_os_version="-mios-version-min=$deployment_target"
	elif [ $platform == "iPhoneSimulator" ]; then
		min_os_version="-mios-simulator-version-min=$deployment_target"
	elif [ $platform == "AppleTVOS" ]; then
		min_os_version="-mtvos-version-min=$deployment_target"
	elif [ $platform == "AppleTVSimulator" ]; then
		min_os_version="-mtvos-simulator-version-min=$deployment_target"
	elif [ $platform == "MacOSX" ]; then
		min_os_version="-mmacos-version-min=$deployment_target"
	else
		min_os_version=""
	fi

	# Setup environment variables for compilation
	local sdk=$(echo $platform | tr '[:upper:]' '[:lower:]')
	local cc="xcrun -sdk $sdk clang -arch $arch $min_os_version"
	local cflag="-arch $arch"
	local cxxflags="$cflag"
	local ldflags="$cflag"

	# Create scratch directory and move to it
	mkdir -p "$SCRATCH/$arch"
	cd "$SCRATCH/$arch"

	# Configure and compile
	CC=$cc $cwd/$SOURCE/configure \
		$CONFIGURE_FLAGS \
		--host=$host \
		--prefix="$THIN/$arch" \
		CC="$cc" CFLAGS="$cflag" LDFLAGS="$ldflags"

	# Install the compiled files
	make -j3 -s install

	# Return to the previous directory
	cd $cwd
}

# Make universal libraries for the specified architectures
make_universal_libs_for_archs() {
	local cwd=$(pwd) # Current working directory
	local archs=$1 # Architectures

	info "Building universal library for architectures: $archs"

	# Create FAT directory
	mkdir -p $FAT/lib

	# Split architectures into an array
	set - $archs

	cd $THIN/$1/lib

	# Create universal libraries
	for lib in *.a; do
		cd $cwd

		lipo -create $(find $THIN -name $lib) -output $FAT/lib/$lib
		info "Universal library: $lib created"
	done
	cd $cwd

	# Copy include files
	cp -rf $THIN/$1/include $FAT
}

# Make framework function
make_framework() {
	local name=$1 # Framework name
	local min_os_version=$2 # Minimum OS version
	local framework="$name/lame.framework" # Framework directory

	# Remove existing framework
	rm -rf $framework

	# Create framework directories
	mkdir -p $framework/Headers/
	mkdir -p $framework/Modules/

	# Create module map
	echo "framework module lame { header \"lame.h\" export * }" >$framework/Modules/module.modulemap

	# Copy headers and library
	cp -rf $FAT/include/lame/* $framework/Headers/
	cp -f $FAT/lib/libmp3lame.a $framework/lame

	# Create Info.plist
	cat << EOF > $framework/Info.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleIdentifier</key>
    <string>com.pro100andrey.lame</string>
    <key>CFBundleName</key>
    <string>lame</string>
    <key>CFBundleVersion</key>
    <string>$bundleVersion</string>
	<key>CFBundleShortVersionString</key>
	<string>$bundleVersion</string>
    <key>CFBundlePackageType</key>
    <string>FMWK</string>
    <key>CFBundleExecutable</key>
    <string>lame</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
	<key>MinimumOSVersion</key>
    <string>$min_os_version</string>
</dict>
</plist>
EOF

	# Clean up temporary directories
	rm -rf $FAT $THIN $SCRATCH
}

# Make xcframework function
make_xcframework() {
	info "Building xcframework"

	# Remove existing xcframework
	if [ -d "lame.xcframework" ]; then
		info "Removing previous xcframework"
		rm -rf lame.xcframework
	fi

	# Initialize xcodebuild arguments
	local xcodebuild_args=("-verbose" "-create-xcframework")

	# Add each framework to the arguments
	for arg in "$@"; do
		xcodebuild_args+=("-framework" "${arg}/lame.framework")
	done

	# Set the output path
	xcodebuild_args+=("-output" "lame.xcframework")

	# Create the xcframework
	xcodebuild "${xcodebuild_args[@]}"

	# Clean up frameworks
	for arg in "$@"; do
		rm -rf "${arg}"
	done
}

# Clean function
clean() {
	rm -rf $SOURCE $FAT $SCRATCH $THIN $LAME_FILE
}

# Build iOS Simulator framework
make_ios_simulator_framework() {
	local name=$1

	# Compile for arm64 and x86_64 architectures
	compile arm64 arm-apple-darwin "iPhoneSimulator"
	compile x86_64 x86_64-apple-darwin "iPhoneSimulator"

	# Create universal libraries
	make_universal_libs_for_archs "arm64 x86_64"

	# Create the framework
	make_framework $name $minVersionIos
}

# Build tvOS Simulator framework
make_tvos_simulator_framework() {
	local name=$1

	# Compile for arm64 and x86_64 architectures
	compile arm64 arm-apple-darwin "AppleTVSimulator"
	compile x86_64 x86_64-apple-darwin "AppleTVSimulator"

	# Create universal libraries
	make_universal_libs_for_archs "arm64 x86_64"

	# Create the framework
	make_framework $name $minVersionTvOS
}

# Build tvOS framework
make_tvos_framework() {
	local name=$1

	# Compile for arm64 architecture
	compile arm64 arm-apple-darwin "AppleTVOS"

	# Create universal libraries
	make_universal_libs_for_archs arm64

	# Create the framework
	make_framework $name $minVersionTvOS
}

# Build iOS framework
make_ios_framework() {
	local name=$1

	# Compile for arm64 architecture
	compile arm64 arm-apple-darwin "iPhoneOS"

	# Create universal libraries
	make_universal_libs_for_archs arm64

	# Create the framework
	make_framework $name $minVersionIos
}

# Build macOS framework
make_macos_framework() {
	local name=$1

	# Compile for arm64 and x86_64 architectures
	compile arm64 arm-apple-darwin "MacOSX"
	compile x86_64 x86_64-apple-darwin "MacOSX"

	# Create universal libraries
	make_universal_libs_for_archs "arm64 x86_64"

	# Create the framework
	make_framework $name $minVersionMacOS
}

# Build Mac Catalyst framework
make_maccatalist_framework() {
	local name=$1

	# Compile for arm64 and x86_64 architectures
	compile_mac_catalyst arm64 arm-apple-darwin "MacOSX"
	compile_mac_catalyst x86_64 x86_64-apple-darwin "MacOSX"

	# Create universal libraries
	make_universal_libs_for_archs "arm64 x86_64"

	# Create the framework
	make_framework $name $minVersionMacOS
}

# Build all frameworks
make_framewokrs() {
	local ios="ios-arm64"
	local ios_simulator="ios-arm64_x86_64-simulator"
	local tvos="tvos-arm64"
	local tvos_simulator="tvos-arm64_x86_64-simulator"
	local macos="macos-arm64_x86_64"
	local maccatalyst="maccatalyst-arm64_x86_64"

	# Build individual frameworks
	make_ios_framework $ios
	make_ios_simulator_framework $ios_simulator
	make_tvos_framework $tvos
	make_tvos_simulator_framework $tvos_simulator
	make_macos_framework $macos
	make_maccatalist_framework $maccatalyst

	# Create xcframework
	make_xcframework $ios $ios_simulator \
		$tvos $tvos_simulator \
		$macos $maccatalyst
}

# Main execution
main() {
	# Initialize global variables
	initialize_global_variables

	# Remove previous build
	remove_lame

	# Download and extract LAME
	download_lame
	extract_lame_tarball

	# Build frameworks
	make_framewokrs

	# Clean up
	clean
}

# Execute the main function
main
