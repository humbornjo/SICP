TEST_FILES := $(wildcard ex*.scm)
CHICKEN := $(shell command -v csi 2>/dev/null)

.PHONY: all env test clean help

all: test

env:
	@if [ -z "$(CHICKEN)" ]; then \
		echo "Installing Chicken Scheme..."; \
		brew install chicken; \
	fi

test: env
	@rm -f .test_failures; \
	for file in $(TEST_FILES); do \
		result=$$(csi -s "$$file" 2>&1); \
		status=$$?; \
		if [ $$status -eq 0 ]; then \
			echo "✓ PASS: $$file"; \
		else \
			echo "✗ FAIL: $$file"; \
			echo "$$result" | sed 's/^/  /'; \
			echo "$$file" >> .test_failures; \
		fi; \
	done; \
	fail_count=$$(wc -l < .test_failures 2>/dev/null || echo 0); \
	pass_count=$$(($(words $(TEST_FILES)) - fail_count)); \
	echo ""; \
	echo "Test Summary: $$pass_count passed, $$fail_count failed"; \
	if [ $$fail_count -gt 0 ]; then \
		echo "Some tests failed"; \
		rm -f .test_failures; \
		exit 1; \
	else \
		echo "All tests passed"; \
		rm -f .test_failures; \
	fi


clean:
	@rm -f *.test .test_failures

help:
	@echo "Available targets:"
	@echo "  all   - Run all tests (default)"
	@echo "  test  - Run tests for ex*.scm files"
	@echo "  env   - Ensure Chicken Scheme is installed"
	@echo "  clean - Remove test artifacts"
	@echo "  help  - Show this help"

# Ensure .scm extension is used for test files
TEST_FILES := $(filter %.scm,$(wildcard ex*))
