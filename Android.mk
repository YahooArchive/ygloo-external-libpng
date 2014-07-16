LOCAL_PATH:= $(call my-dir)

# We need to build this for both the device (as a shared library)
# and the host (as a static library for tools to use).

common_SRC_FILES := png.c
common_SRC_FILES += pngset.c
common_SRC_FILES += pngget.c
common_SRC_FILES += pngrutil.c
common_SRC_FILES += pngtrans.c
common_SRC_FILES += pngwutil.c
common_SRC_FILES += pngread.c
common_SRC_FILES += pngrio.c
common_SRC_FILES += pngwio.c
common_SRC_FILES += pngwrite.c
common_SRC_FILES += pngrtran.c
common_SRC_FILES += pngwtran.c
common_SRC_FILES += pngmem.c
common_SRC_FILES += pngerror.c
common_SRC_FILES += pngpread.c

common_CFLAGS := -std=gnu89 -fvisibility=hidden ## -fomit-frame-pointer

ifeq ($(HOST_OS),windows)
  ifeq ($(USE_MINGW),)
    # Case where we're building windows but not under linux (so it must be cygwin)
    # In this case, gcc cygwin doesn't recognize -fvisibility=hidden
    $(info libpng: Ignoring gcc flag $(common_CFLAGS) on Cygwin)
    common_CFLAGS := 
  endif
endif

common_C_INCLUDES += 

common_COPY_HEADERS_TO := libpng
common_COPY_HEADERS := png.h pngconf.h pngusr.h

# Static library
include $(CLEAR_VARS)

LOCAL_MODULE:= libyahoo_png
LOCAL_CLANG := true
LOCAL_SRC_FILES := $(common_SRC_FILES)
LOCAL_CFLAGS += $(common_CFLAGS) -ftrapv
LOCAL_C_INCLUDES += $(common_C_INCLUDES)
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../zlib

LOCAL_STATIC_LIBRARIES := libyahoo_zlib

# Force compiling the static library as PIC so it can be embedded
# into a shared library later
LOCAL_CFLAGS += -fPIC -DPIC

include $(BUILD_STATIC_LIBRARY)

# Test application
include $(CLEAR_VARS)

LOCAL_MODULE := pngtest
LOCAL_CLANG := true
LOCAL_C_INCLUDES:= $(common_C_INCLUDES)
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../zlib
LOCAL_SRC_FILES:= pngtest.c
LOCAL_STATIC_LIBRARIES:= libyahoo_png libyahoo_zlib
LOCAL_MODULE_TAGS := debug

include $(BUILD_EXECUTABLE)
