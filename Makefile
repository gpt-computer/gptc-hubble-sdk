# Run:
#   make help
#
# for a description of the available targets


# ------------------------------------------------------------------------- Help target

TARGET_MAX_CHAR_NUM=20
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)

## Show this help message
help:
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  ${YELLOW}%-$(TARGET_MAX_CHAR_NUM)s${RESET} ${GREEN}%s${RESET}\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)


# ------------------------------------------------------------------------ Clean target

## Delete temp operational stuff like artifacts, test outputs etc
clean:
	rm -rf .mypy_cache/
	rm -rf .pytest_cache/
	rm -f .coverage
	rm -f .coverage.*
	rm -rf htmlcov/


# --------------------------------------------------------- Environment related targets

## Create a virtual environment
env:
	uv venv

## Install pre-commit hooks
pre-commit:
	uv run --with pre-commit pre-commit install

## Install package and dev dependencies
init:
	uv sync --group dev


# ---------------------------------------------------------------- Test related targets

PYTEST_ARGS = --show-capture no --full-trace --verbose --cov hubble/ --cov-report term-missing --cov-report xml

## Run tests
test:
	uv run pytest $(PYTEST_ARGS) $(TESTS_PATH)


# ---------------------------------------------------------- Code style related targets

SRC_CODE = hubble/ tests/

## Run the flake linter
flake:
	uv run flake8 $(SRC_CODE) --exclude hubble/resources

## Run the black formatter
black:
	uv run black $(SRC_CODE) --extend-exclude hubble/resources

## Dry run the black formatter
black-check:
	uv run black --check $(SRC_CODE) --extend-exclude hubble/resources

## Run the isort import formatter
isort:
	uv run isort $(SRC_CODE)

## Dry run the isort import formatter
isort-check:
	uv run isort --check $(SRC_CODE)

## Run the mypy static type checker
mypy:
	uv run mypy $(SRC_CODE) --exclude hubble/resources

## Format source code
format: black isort

## Check code style
style: flake black-check isort-check # mypy
