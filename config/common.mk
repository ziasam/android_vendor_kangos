# Copyright (C) 2019 KangOS
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include vendor/kangos/config/fingerprint.mk
include vendor/kangos/config/version.mk

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/kangos/overlay
DEVICE_PACKAGE_OVERLAYS += \
    vendor/kangos/overlay/common

ifeq ($(USE_GAPPS), true)
$(call inherit-product, vendor/gapps/gapps.mk)
endif

include vendor/kangos/config/ProductConfigQcom.mk

PRODUCT_SOONG_NAMESPACES += $(PATHMAP_SOONG_NAMESPACES)

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# Backup Tool
ifeq ($(AB_OTA_UPDATER),true)
PRODUCT_COPY_FILES += \
    vendor/kangos/prebuilt/common/bin/backuptool_ab.sh:system/bin/backuptool_ab.sh \
    vendor/kangos/prebuilt/common/bin/backuptool_ab.functions:system/bin/backuptool_ab.functions \
    vendor/kangos/prebuilt/common/bin/backuptool_postinstall.sh:system/bin/backuptool_postinstall.sh
endif

# Flipendo
PRODUCT_COPY_FILES += \
    vendor/kangos/config/permissions/pixel_experience_2020.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/pixel_experience_2020.xml

# KangOS-specific
PRODUCT_COPY_FILES += \
    vendor/kangos/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/kangos/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/kangos/prebuilt/common/bin/50-cm.sh:system/addon.d/50-cm.sh

# Copy all custom init rc files
$(foreach f,$(wildcard vendor/kangos/prebuilt/common/etc/init/*.rc),\
	$(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/etc/init/$(notdir $f)))

# system mount
PRODUCT_COPY_FILES += \
    vendor/kangos/prebuilt/common/bin/system-mount.sh:install/bin/system-mount.sh

# Enforce privapp-permissions whitelist
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.control_privapp_permissions=log

# Do not include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Packages
include vendor/kangos/config/packages.mk

# Props
include vendor/kangos/config/props.mk

# RevengeUI
include vendor/revengeui/config.mk

# Sensitive Phone Numbers list
PRODUCT_COPY_FILES += \
    vendor/kangos/prebuilt/common/etc/sensitive_pn.xml:system/etc/sensitive_pn.xml

# Priv-app permissions
ifeq ($(KANGOS_BUILDTYPE),OFFICIAL)
PRODUCT_COPY_FILES += \
    vendor/kangos/config/permissions/com.kangos.ota.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/com.kangos.ota.xml
endif

PRODUCT_COPY_FILES += \
    vendor/kangos/config/permissions/com.android.screenshot.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/com.android.screenshot.xml \
    vendor/kangos/config/permissions/privapp-permissions-livedisplay-product.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-livedisplay-product.xml \
    vendor/kangos/config/permissions/privapp-permissions-kangos-system.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-kangos-system.xml \
    vendor/kangos/config/permissions/privapp-permissions-kangos-product.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-kangos-product.xml

# Hidden API whitelist
PRODUCT_COPY_FILES += \
    vendor/kangos/config/sysconfig/kangos-hiddenapi-package-whitelist.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/kangos-hiddenapi-package-whitelist.xml

# Face Unlock
TARGET_FACE_UNLOCK_SUPPORTED := true
ifneq ($(TARGET_DISABLE_ALTERNATIVE_FACE_UNLOCK), true)
PRODUCT_PACKAGES += \
    FaceUnlockService
TARGET_FACE_UNLOCK_SUPPORTED := true
endif
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.face.moto_unlock_service=$(TARGET_FACE_UNLOCK_SUPPORTED)

# Fonts
include vendor/kangos/fonts.mk

