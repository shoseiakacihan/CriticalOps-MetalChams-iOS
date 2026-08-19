ARCHS = arm64
DEBUG = 1
FINALPACKAGE = 1
FOR_RELEASE = 1
IGNORE_WARNINGS = 1

THEOS := $(HOME)/theos

include $(THEOS)/makefiles/common.mk

TC_PATH = /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain

export TARGET_CC=$(TC_PATH)/usr/bin/clang
export TARGET_CXX=$(TC_PATH)/usr/bin/clang++
TWEAK_NAME = metalchams

metalchams_FRAMEWORKS = UIKit Foundation Metal MetalKit

metalchams_CFLAGS = -fobjc-arc -fmodules -Wno-deprecated-declarations -Wno-unused-variable -w -fvisibility=hidden
metalchams_FILES = Tweak.mm

include $(THEOS_MAKE_PATH)/tweak.mk
