all:
	xcodebuild -arch "i386" -configuration "Debug" -sdk "iphonesimulator" -workspace "ColorClock.xcworkspace" -scheme "ColorClock" clean build | xcpretty
	xcodebuild -arch "i386" -configuration "Debug" -sdk "iphonesimulator" -workspace "ColorClock.xcworkspace" -scheme "ColorClock" test
