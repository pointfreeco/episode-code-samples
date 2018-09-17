init:
	git submodule update --init
	xcrun swift package --package-path Vendor/Stencil generate-xcodeproj

install-mm-xcodeproj: 
	@ls MyApp.xcodeproj/GeneratedModuleMap | xargs -n1 -I '{}' $(SUDO) mkdir -p "$(FRAMEWORKS_PATH)/{}.framework"
	@ls MyApp.xcodeproj/GeneratedModuleMap | xargs -n1 -I '{}' $(SUDO) cp "./MyApp.xcodeproj/GeneratedModuleMap/{}/module.modulemap" "$(FRAMEWORKS_PATH)/{}.framework/module.map"

SDK_PATH = $(shell xcrun --show-sdk-path 2>/dev/null)
FRAMEWORKS_PATH = $(SDK_PATH)/System/Library/Frameworks
SUDO = sudo --prompt=$(SUDO_PROMPT)
SUDO_PROMPT = "  🔒 Please enter your password: "
