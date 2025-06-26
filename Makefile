.PHONY: install install-auto install-recovery update backup restore uninstall status help
.DEFAULT_GOAL := help

help: ## Show this help message
	@echo "📋 Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

install: ## Install dotfiles (interactive mode)
	@echo "🎙  Installing dotfiles"
	@./bootstrap.sh

install-auto: ## Install dotfiles (non-interactive mode)
	@echo "🤖 Installing dotfiles (auto mode)"
	@./bootstrap.sh --yes

install-recovery: ## Resume failed installation from last step
	@echo "🔄 Resuming installation"
	@./bootstrap.sh --recovery

status: ## Show current bootstrap status and last run info
	@echo "📊 Bootstrap Status:"
	@source ./state.sh && show_progress
	@echo ""
	@echo "📅 Last run: $$(source ./state.sh && get_last_run)"

update: ## Update all installed programs and plugins
	@echo "🔄 Updating all programs"
	@source ./functions/functions.sh && update_all

backup: ## Create backup of existing configurations
	@echo "💾 Creating backup"
	@./backup.sh

restore: ## Restore from last backup
	@echo "🔄 Restoring from backup"
	@if [ -f ~/.dotfiles-last-backup ]; then \
		BACKUP_DIR=$$(cat ~/.dotfiles-last-backup); \
		if [ -f "$$BACKUP_DIR/restore.sh" ]; then \
			$$BACKUP_DIR/restore.sh; \
		else \
			echo "❌ Restore script not found in $$BACKUP_DIR"; \
		fi; \
	else \
		echo "❌ No backup found. Run 'make backup' first."; \
	fi

uninstall: ## Remove all dotfiles and installed programs
	@echo "🗑️  Uninstalling dotfiles"
	@./uninstall.sh

# Legacy aliases
configure-mac: install ## Legacy alias for install
