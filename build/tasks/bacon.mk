# Copyright (C) 2017 Unlegacy-Android
# Copyright (C) 2017 The LineageOS Project
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

# -----------------------------------------------------------------

# Build system colors
ifneq ($(BUILD_WITH_COLORS),0)
 CL_RED="\033[31m"
  CL_GRN="\033[32m"
  CL_YLW="\033[33m"
  CL_BLU="\033[34m"
  CL_MAG="\033[35m"
  CL_CYN="\033[36m"
  CL_RST="\033[0m"
endif

# KangOS package
KANGOS_TARGET_PACKAGE := $(PRODUCT_OUT)/KangOS-$(KANGOS_BUILD_ID).zip

.PHONY: otapackage bacon
otapackage: $(INTERNAL_OTA_PACKAGE_TARGET)
bacon: otapackage
	$(hide) ln -f $(INTERNAL_OTA_PACKAGE_TARGET) $(KANGOS_TARGET_PACKAGE)
	$(hide) $(MD5SUM) $(KANGOS_TARGET_PACKAGE) | sed "s|$(PRODUCT_OUT)/||" > $(KANGOS_TARGET_PACKAGE).md5sum
	@echo "done"
	@echo "===============================-Package complete-============================================================="
	@echo "Zip: $(KANGOS_TARGET_PACKAGE)"
	@echo "MD5: `cat $(KANGOS_TARGET_PACKAGE).md5sum | awk '{print $$1}' `"
	@echo "Size: `du -sh $(KANGOS_TARGET_PACKAGE) | awk '{print $$1}' `"
	@echo "=============================================================================================================="
	echo -e ${CL_RED}"							"${CL_RST}
	echo -e ${CL_RED}"====  __  __                      ___  ____  	====="${CL_RST}
	echo -e ${CL_RED}"====  | |/ / __ _ _ __   __ _    / _ \/ ___| 	====="${CL_RST}
	echo -e ${CL_BLU}"====  | | / / _  |  _ \ / _  |  | | | \___ \ 	====="${CL_RST}
	echo -e ${CL_CYN}"====  | |  \ (_| | | | | (_| |  | |_| |___) |	====="${CL_RST}
	echo -e ${CL_RED}"====  |_|\__\__,_|_| |_|\__, |___\___/|____/ 	====="${CL_RST}
	echo -e ${CL_RED}"====                   |___/_____|          	====="${CL_RST}
	echo -e ${CL_BLU}" =================================================="${CL_RED}
	@echo "Kanged Everything Ready to Rock"
