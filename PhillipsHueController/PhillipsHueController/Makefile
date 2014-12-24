CLANG	    = /usr/bin/clang
ARCH	    = -arch armv7
SDK	    = -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS8.1.sdk
OS_VER_MIN  = -miphoneos-version-min=7.1
OPTIONS     = -fsyntax-only -x objective-c -fobjc-arc -fpascal-strings -DDEBUG=1 -fexceptions -fasm-blocks -fstrict-aliasing -g -fobjc-abi-version=2 -fobjc-legacy-dispatch
WARNINGS    = -Weverything
FRAMEWORKS  = -F./../
INCLUDES    = -I.

check-syntax:
	$(CLANG) $(OPTIONS) $(ARCH) $(WARNINGS) $(SDK) $(OS_VER_MIN) $(INCLUDES)  ${FRAMEWORKS} -framework Foundation -framework UIKit ${CHK_SOURCES}
