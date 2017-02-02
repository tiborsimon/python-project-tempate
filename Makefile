.PHONY: help verison status test install uninstall dev-install dev-uninstall build upload clean clean-pyc

NAME := mytool
PYTHON := python2
USER := --user

help:
	@echo "---------------------------------------------------------------------"
	@echo " $(BOLD_NAME) - M A K E   I N T E R F A C E"
	@echo "---------------------------------------------------------------------"
	@echo " make $(BOLD)help$(RESET)           Prints out this help message."
	@echo " make $(BOLD)version$(RESET)        Prints out the verison number."
	@echo " make $(BOLD)status$(RESET)         Prints out the installation status."
	@echo " make $(BOLD)test$(RESET)           Runs the test suite."
	@echo " make $(BOLD)install$(RESET)        Installs $(NAME) in the regular static way."
	@echo " make $(BOLD)uninstall$(RESET)      Uninstalls the static installation of $(NAME)."
	@echo " make $(BOLD)dev-install$(RESET)    Installs $(NAME) in developer mode."
	@echo " make $(BOLD)dev-uninstall$(RESET)  Uninstalls the development mode."
	@echo " make $(BOLD)build$(RESET)          Builds $(NAME) for distribution."
	@echo " make $(BOLD)upload$(RESET)         Upload $(NAME) to PyPi with twine."
	@echo " make $(BOLD)clean$(RESET)          Cleans up all generated artifacts."
	@echo " make $(BOLD)clean-pyc$(RESET)      Cleans up all precompiled cached files."
	@echo ""

BOLD := $(shell tput bold)
RED := $(shell tput setaf 1)
GREEN := $(shell tput setaf 2)
YELLOW := $(shell tput setaf 3)
RESET:= $(shell tput sgr0)

BOLD_NAME := $(BOLD)$(NAME)$(RESET)

TASK    := [ $(BOLD)$(GREEN)>>$(RESET) ]
OK      := [ $(BOLD)$(GREEN)OK$(RESET) ]
WARNING := [ $(BOLD)$(YELLOW)!!$(RESET) ]
ERROR   := [$(BOLD)$(RED)FAIL$(RESET)]

STATIC_INDICATOR := .INSTALLED
DEVELOP_INDICATOR := .DEVELOP-INSTALLED

ERROR_INSTALLED := "$(ERROR) $(NAME) was already installed in static mode. Run $(BOLD)make uninstall$(RESET) first!"
ERROR_DEV_INSTALLED := "$(ERROR) $(NAME) was already installed in development mode. Run $(BOLD)make dev-uninstall$(RESET) first!"
ERROR_NOT_INSTALLED := "$(ERROR) $(NAME) was not installed yet. Run $(BOLD)make install$(RESET) first!"
ERROR_NOT_DEV_INSTALLED := "$(ERROR) $(NAME) was not installed in development mode. Run $(BOLD)make dev-install$(RESET) first!"
ERROR_NOT_INSTALLED_YET := "$(ERROR) No installation was found for $(BOLD_NAME). Run $(BOLD)make install$(RESET) or $(BOLD)make dev-install$(RESET) first!"

test:
	$(PYTHON) -m unittest discover

version:
	@echo "$(TASK) Interrogating the version of $(BOLD_NAME).."
	@echo "$(OK) Done."

status:
	@echo "$(TASK) Interrogating installation status.."
	@if [ ! -f $(STATIC_INDICATOR) ] && [ ! -f $(DEVELOP_INDICATOR) ]; then echo $(ERROR_NOT_INSTALLED_YET); fi
	@if [ -f $(STATIC_INDICATOR) ]; then echo "$(BOLD_NAME) was installed in static mode.";fi
	@if [ -f $(DEVELOP_INDICATOR) ]; then echo "$(BOLD_NAME) was installed in development mode.";fi
	@echo "$(OK) Done."

install:
	@echo "$(TASK) Installing $(BOLD_NAME) in static mode.."
	@if [ -f $(STATIC_INDICATOR) ]; then echo $(ERROR_INSTALLED); exit 1; fi
	@if [ -f $(DEVELOP_INDICATOR) ]; then echo $(ERROR_DEV_INSTALLED); exit 1; fi
	@$(PYTHON) setup.py install --record $(STATIC_INDICATOR) $(USER)
	@echo "$(OK) $(BOLD_NAME) was installed."

uninstall:
	@echo "$(TASK) Uninstalling $(BOLD_NAME).."
	@if [ -f $(DEVELOP_INDICATOR) ]; then echo $(ERROR_DEV_INSTALLED); exit 1; fi
	@if [ ! -f $(STATIC_INDICATOR) ]; then echo $(ERROR_NOT_INSTALLED); exit 1; fi
	@cat $(STATIC_INDICATOR) | xargs -r rm -rvf
	@rm -rvf $(STATIC_INDICATOR)
	@echo "$(OK) $(BOLD_NAME) was uninstalled."

dev-install:
	@echo "$(TASK) Installing $(BOLD_NAME) in development mode.."
	@if [ -f $(STATIC_INDICATOR) ]; then echo $(ERROR_INSTALLED); exit 1; fi
	@if [ -f $(DEVELOP_INDICATOR) ]; then echo $(ERROR_DEV_INSTALLED); exit 1; fi
	@$(PYTHON) setup.py develop $(USER)
	touch $(DEVELOP_INDICATOR)
	@echo "$(OK) $(BOLD_NAME) development mode was installed."

dev-uninstall:
	@echo "$(TASK) Uninstalling $(BOLD_NAME).."
	@if [ -f $(STATIC_INDICATOR) ]; then echo $(ERROR_INSTALLED); exit 1; fi
	@if [ ! -f $(DEVELOP_INDICATOR) ]; then echo $(ERROR_NOT_DEV_INSTALLED); exit 1; fi
	$(PYTHON) setup.py develop $(USER) --uninstall
	@rm -rfv $(shell which $(NAME)) $(DEVELOP_INDICATOR)
	@echo "$(OK) $(BOLD_NAME) development mode was uninstalled."

clean: clean-pyc
	@echo "$(TASK) Cleaning up build artifacts.."
	@rm -rfv dist regx.egg-info build
	@find . -name "*.pyc" | xargs -r rm -fv
	@find . -name "__pycache__" | xargs -r rm -fvr
	@echo "$(OK) Build artifacts were deleted."

clean-pyc:
	@echo "$(TASK) Cleaning up precompiled cached files.."
	@rm -rfv dist regx.egg-info build
	@find . -name "*.pyc" | xargs -r rm -fv
	@find . -name "__pycache__" | xargs -r rm -fvr
	@echo "$(OK) Cached files were deleted."

build: clean
	@echo "$(TASK) Building release packages.."
	@python2 setup.py sdist bdist_wheel --universal
	@python3 setup.py bdist_wheel --universal
	@echo "$(OK) $(BOLD_NAME) was built."

upload: dist
	@echo "$(TASK) Attempting to upload $(BOLD_NAME) ot PyPi.."
	@twine upload dist/*
	@echo "$(OK) $(BOLD_NAME) was uploaded to PyPi."

