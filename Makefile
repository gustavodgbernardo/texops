# Usage:
#   make pdf                 Build build/main.pdf (needs a local TeX install or the Dev Container)
#   make diff BASE=main      Build build/diff.pdf highlighting changes since BASE
#   make lint                Run chktex on the sources
#   make docker-pdf          Same as `make pdf`, but inside Docker (nothing else to install)
#   make docker-diff         Same as `make diff`, but inside Docker
#   make clean               Remove build output

PAPER_DIR := paper
MAIN      := main
BUILD_DIR := build
BASE      ?= origin/main
IMAGE     := texops:local

LATEXMK := latexmk -outdir=../$(BUILD_DIR)

.PHONY: pdf diff lint clean docker-image docker-pdf docker-diff

pdf:
	cd $(PAPER_DIR) && $(LATEXMK) $(MAIN).tex

diff:
	./scripts/diff.sh $(BASE)

lint:
	chktex -q -n1 -n8 -n24 -n46 $(PAPER_DIR)/$(MAIN).tex $(PAPER_DIR)/sections/*.tex

clean:
	rm -rf $(BUILD_DIR) $(PAPER_DIR)/diff.tex

docker-image:
	docker build -t $(IMAGE) .

DOCKER_RUN := docker run --rm -v "$(CURDIR)":/workspace -w /workspace \
	--user "$$(id -u):$$(id -g)" -e HOME=/tmp $(IMAGE)

docker-pdf: docker-image
	$(DOCKER_RUN) make pdf

docker-diff: docker-image
	$(DOCKER_RUN) make diff BASE=$(BASE)
