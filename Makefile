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

install_deps: ## install dependencies like oh-my-zsh
install_deps: install_oh_my_zsh
install_deps: install_tpm

install_oh_my_zsh:
	@echo "Install oh_my_zsh"
	$(Q) curl -s -L -o oh-my-zsh-master.tar.gz https://github.com/robbyrussell/oh-my-zsh/archive/master.tar.gz
	$(CHEZMOI) import --strip-components 1 --destination ${HOME}/.oh-my-zsh oh-my-zsh-master.tar.gz
	$(Q) rm -rfv oh-my-zsh-master.tar.gz

install_tpm:
	@echo "Install tpm"
	$(Q) curl -s -L -o tpm.tar.gz https://github.com/tmux-plugins/tpm/archive/master.tar.gz
	$(CHEZMOI) import --strip-components 1 --destination  ${HOME}/.tmux/plugins/tpm/ tpm.tar.gz
	$(Q) rm -rfv tpm.tar.gz

clean: ## clean
	rm -r $(CHEZMOI_BIN)
	rm -r *.tar.gz~

# Check http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: ## Print this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
