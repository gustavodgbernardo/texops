# Usage:
#   make pdf                 Build build/main.pdf (needs a local TeX install or the Dev Container)
#   make diff BASE=main      Build build/diff.pdf highlighting changes since BASE
#   make lint                Run chktex on the sources
#   make docker-pdf          Same as `make pdf`, but inside Docker (nothing else to install)
#   make docker-diff         Same as `make diff`, but inside Docker
#   make editor-pdf          Used by VS Code: Docker on the host, plain latexmk inside the Dev Container
#   make clean               Remove build output

PAPER_DIR := paper
MAIN      := main
BUILD_DIR := build
BASE      ?= origin/main
IMAGE     := texops:local

LATEXMK := latexmk -outdir=../$(BUILD_DIR)

.PHONY: pdf diff lint clean docker-image docker-pdf docker-diff editor-pdf

pdf:
	cd $(PAPER_DIR) && $(LATEXMK) $(MAIN).tex

diff:
	./scripts/diff.sh $(BASE)

lint:
	chktex -q -n1 -n8 -n24 -n46 $(PAPER_DIR)/$(MAIN).tex $(PAPER_DIR)/sections/*.tex

clean:
	rm -rf $(BUILD_DIR) $(PAPER_DIR)/diff.tex

docker-image:
	docker build -q -t $(IMAGE) . > /dev/null

# The project is mounted at the same path as on the host, so SyncTeX
# (PDF <-> source navigation) works when an editor on the host uses Docker.
DOCKER_RUN := docker run --rm -v "$(CURDIR)":"$(CURDIR)" -w "$(CURDIR)" \
	--user "$$(id -u):$$(id -g)" -e HOME=/tmp $(IMAGE)

docker-pdf: docker-image
	$(DOCKER_RUN) make pdf

docker-diff: docker-image
	$(DOCKER_RUN) make diff BASE=$(BASE)

editor-pdf:
	@if command -v docker >/dev/null 2>&1; then $(MAKE) --no-print-directory docker-pdf; else $(MAKE) --no-print-directory pdf; fi
