TEST_FILES := $(wildcard ex*)

env:
	@command -v csi || brew install chicken

test: env
	@for file in $(TEST_FILES); do \
		result=$$(csi -s "$$file" 2>&1); \
		if [[ $$? -eq 0 ]]; then \
			echo "PASS: $$file"; \
		else \
			echo "FAIL: $$file\n$$result"; \
		fi; \
	done

.PHONY: test env
