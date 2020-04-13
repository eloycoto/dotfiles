# Chezmoi config
CHEZMOI_VERSION=1.7.19
CHEZMOI_BIN=chezmoi
CHEZMOI=./chezmoi -S $(PWD)

# Makefile confi
Q = @

# varargs
RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(RUN_ARGS):;@:)

.PHONY: chezmoi

install_chezmoi:
ifeq ("$(wildcard $(CHEZMOI_BIN))", "")
		@echo "Installing chezmoi"
		$(Q) $(eval TMP := $(shell mktemp -d))
		$(Q) wget https://github.com/twpayne/chezmoi/releases/download/v1.7.19/chezmoi_$(CHEZMOI_VERSION)_linux_amd64.tar.gz \
				-O $(TMP)/chezmoi.tar.gz 2> /dev/null
		$(Q) tar xfz $(TMP)/chezmoi.tar.gz -C $(TMP)
		$(Q) cp $(TMP)/chezmoi $(CHEZMOI_BIN)
		@echo "Installing successfully in $(CHEZMOI_BIN)"
endif

chezmoi: ## Running chezmoi application
chezmoi: install_chezmoi
	$(CHEZMOI) $(RUN_ARGS)

install: ## Install
	$(CHEZMOI) apply

clean: ## clean
	rm -r chezmoi

# Check http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: ## Print this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
