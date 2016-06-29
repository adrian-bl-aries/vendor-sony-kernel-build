ifeq ($(BUILD_KERNEL),false)
ifeq ($(filter-out rhine shinano kitakami kanuti,$(PRODUCT_PLATFORM)),)
LOCAL_PATH := $(call my-dir)

TARGET_PREBUILT_KERNEL := $(LOCAL_PATH)/kernel-dtb-$(TARGET_DEVICE)
INSTALLED_KERNEL_TARGET ?= $(PRODUCT_OUT)/kernel

file := $(INSTALLED_KERNEL_TARGET)
ALL_PREBUILT += $(file)
$(file) : $(TARGET_PREBUILT_KERNEL) | $(ACP)
	$(transform-prebuilt-to-target)

ALL_PREBUILT += $(INSTALLED_KERNEL_TARGET)
endif

ifeq ($(filter-out yukon,$(PRODUCT_PLATFORM)),)
LOCAL_PATH := $(call my-dir)

TARGET_PREBUILT_KERNEL := $(LOCAL_PATH)/kernel-$(TARGET_DEVICE)
INSTALLED_KERNEL_TARGET ?= $(PRODUCT_OUT)/kernel

DTB_DIR := $(LOCAL_PATH)/dtbs
DTB_FILES := $(shell find -L $(DTB_DIR) -name "*$(TARGET_DEVICE)*.dtb")
DTB_OUT_DIR := $(PRODUCT_OUT)/dtbs
DTBS := $(foreach dtb,$(DTB_FILES),$(DTB_OUT_DIR)/$(notdir $(dtb)))
$(DTB_OUT_DIR)/%.dtb : $(DTB_DIR)/%.dtb | $(ACP)
	$(hide) @mkdir -p $(DTB_OUT_DIR)
	$(transform-prebuilt-to-target)

file := $(INSTALLED_KERNEL_TARGET)
ALL_PREBUILT += $(file)
$(file) : $(TARGET_PREBUILT_KERNEL) $(DTBS) | $(ACP)
	$(transform-prebuilt-to-target)

ALL_PREBUILT += $(INSTALLED_KERNEL_TARGET)
endif
endif
