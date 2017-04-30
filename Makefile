NAME = RecorderSession
SCHEME = $(NAME) (macOS)
PROJECT = $(NAME).xcodeproj

BUILD_DIR = $(shell pwd)/build
DOCS_DIR = $(shell pwd)/docs
SOURCE_FILES = $(shell pwd)/$(NAME)/**/*.{h,m}

clean:
	rm -rf $(BUILD_DIR)
	rm -rf Carthage
	rm -rf $(NAME).framework.zip
	rm -rf $(DOCS_DIR)

init:
	gem install bundler
	bundle config build.nokogiri \
		--use-system-libraries=true \
		--with-xml2-include=$(shell xcrun --show-sdk-path)/usr/include/libxml2
	bundle
	brew bundle

test:
	bundle exec fastlane scan \
	--clean \
	--project "$(PROJECT)" \
	--scheme "$(SCHEME)" \
	--derived_data_path "$(BUILD_DIR)" \
	--output_directory "$(BUILD_DIR)/TestOutput"

framework:
	carthage build --no-skip-current
	carthage archive $(NAME)

docs:
	jazzy \
	--objc \
	--clean \
	--umbrella-header $(NAME)/$(NAME).h \
	--framework-root $(NAME) \
	--module $(NAME) \
	--hide-documentation-coverage \
	--no-download-badge \
	--sdk macosx \
	--exclude "$(NAME)Tests" \
	--skip-undocumented \
	--output "$(DOCS_DIR)" \
	--author "Marcel Dierkes" \
	--github_url "https://github.com/newmarcel/RecorderSession" \
	--theme fullwidth \
	--author_url "https://github.com/newmarcel"
	open "$(DOCS_DIR)/index.html"

clangformat:
	find "$(shell pwd)" -iname *.h -o -iname *.m | xargs clang-format -style=file -i

.PHONY: clean init test framework docs clangformat
