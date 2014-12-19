CLANG	    = /usr/bin/clang
ARCH	    = -arch armv7
SDK	    = -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.1.sdk
OS_VER_MIN  = -miphoneos-version-min=4.3
OPTIONS     = -fsyntax-only -x objective-c -std=c99 -fobjc-arc
WARNINGS    = -Weverything
INCLUDES    = -I.
FRAMEWORKS  = -F/Users/aono_taketoshi/github/PhilipsHueSDK-iOS-OSX/

check-syntax:
	$(CLANG) $(OPTIONS) $(ARCH) $(WARNINGS) $(SDK) $(OS_VER_MIN) $(INCLUDES) $(FRAMEWORKS) -framework Foundation -framework UIKit ${CHK_SOURCES}
