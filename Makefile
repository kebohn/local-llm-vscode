SHELL := /usr/bin/env bash
.DEFAULT_GOAL := help

MODEL ?= qwen2.5-coder:7b-instruct-q4_K_M
STRONG_MODEL ?= llama3.1:8b-instruct-q4_K_M
RUNS ?= 5

.PHONY: help setup start stop status logs \
	pull pull-fast pull-strong health bootstrap \
	router-start router-health router-bootstrap \
	benchmark benchmark-fast benchmark-strong

help:
	@echo "Available targets:"
	@echo "  make setup               - check Docker/Compose and create .env"
	@echo "  make start               - start Ollama stack"
	@echo "  make pull                - pull MODEL=$(MODEL)"
	@echo "  make pull-fast           - pull fast profile model"
	@echo "  make pull-strong         - pull strong profile model"
	@echo "  make health              - run Ollama endpoint + generation check"
	@echo "  make bootstrap           - setup -> start -> pull -> health"
	@echo "  make router-start        - start Ollama + LiteLLM router profile"
	@echo "  make router-health       - check LiteLLM router endpoint"
	@echo "  make router-bootstrap    - router-start -> pull-fast -> pull-strong -> router-health"
	@echo "  make benchmark           - benchmark MODEL for RUNS"
	@echo "  make benchmark-fast      - benchmark fast model"
	@echo "  make benchmark-strong    - benchmark strong model"
	@echo "  make stop                - stop stack"
	@echo "  make status              - show compose status"
	@echo "  make logs                - follow Ollama logs"
	@echo
	@echo "Examples:"
	@echo "  make bootstrap"
	@echo "  make pull MODEL=codellama:7b-instruct"
	@echo "  make benchmark MODEL=$(STRONG_MODEL) RUNS=3"

setup:
	./scripts/setup.sh

start:
	./scripts/start.sh

stop:
	./scripts/stop.sh

status:
	docker compose ps

logs:
	docker compose logs -f ollama

pull:
	./scripts/pull-model.sh $(MODEL)

pull-fast:
	./scripts/pull-model.sh qwen2.5-coder:7b-instruct-q4_K_M

pull-strong:
	./scripts/pull-model.sh $(STRONG_MODEL)

health:
	./scripts/health.sh $(MODEL)

bootstrap: setup start pull health

router-start:
	./scripts/start-router.sh

router-health:
	./scripts/router-health.sh

router-bootstrap: router-start pull-fast pull-strong router-health

benchmark:
	./scripts/benchmark.sh $(MODEL) $(RUNS)

benchmark-fast:
	./scripts/benchmark.sh qwen2.5-coder:7b-instruct-q4_K_M $(RUNS)

benchmark-strong:
	./scripts/benchmark.sh $(STRONG_MODEL) $(RUNS)
