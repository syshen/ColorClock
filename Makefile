all:
	xcodebuild -arch "i386" -configuration "Debug" -sdk "iphonesimulator" clean build | xcpretty
	xcodebuild -arch "i386" -configuration "Debug" -sdk "iphonesimulator" -scheme "ColorClock" test
