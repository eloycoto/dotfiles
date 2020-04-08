CHEZMOI_VERSION=1.7.19
CHEZMOI=./chezmoi -S $(PWD)

RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(RUN_ARGS):;@:)

.PHONY: chezmoi

install_chezmoi:
	$(eval TMP := $(shell mktemp -d))
	wget https://github.com/twpayne/chezmoi/releases/download/v1.7.19/chezmoi_$(CHEZMOI_VERSION)_linux_amd64.tar.gz \
			-O $(TMP)/chezmoi.tar.gz
	tar xfvz $(TMP)/chezmoi.tar.gz -C $(TMP)
	cp $(TMP)/chezmoi .

chezmoi:
	$(CHEZMOI) $(RUN_ARGS)

install:
	$(CHEZMOI) apply

clean:
	rm -r chezmoi
