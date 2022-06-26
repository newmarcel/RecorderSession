NAME = RecorderSession

BUILD_DIR = build
DOCS_DIR = docs
SOURCE_FILES = $(shell pwd)/$(NAME)/**/*.{h,m}

clean:
	rm -rf $(BUILD_DIR)

test:
	set -o pipefail && env NSUnbufferedIO=YES \
	xcodebuild test \
	-scheme "$(NAME)" \
	-destination "platform=macOS"

clangformat:
	find "$(shell pwd)" -iname *.h -o -iname *.m | xargs clang-format -style=file -i

.PHONY: clean test clangformat
