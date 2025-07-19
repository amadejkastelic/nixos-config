# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Structure

This is a NixOS and Home Manager dotfiles repository using flake-parts for organization. The configuration is split into several main directories:

- `flake.nix` - Main flake entry point with inputs and outputs
- `home/` - Home Manager configurations
- `hosts/` - NixOS host configurations (ryzen desktop, server)
- `system/` - NixOS system modules organized by category
- `lib/` - Custom library functions and utilities
- `pkgs/` - Custom package definitions
- `modules/` - Custom NixOS/Home Manager modules

## Development Commands

### Building and Testing
```bash
# Build the system configuration
sudo nixos-rebuild switch --flake .#ryzen

# Test configuration without switching
sudo nixos-rebuild test --flake .#ryzen

# Build specific packages
nix build .#catppuccin-plymouth
nix build .#wl-ocr
nix build .#bibata-cursors-svg
```

### Development Environment
```bash
# Enter development shell with tools
nix develop

# Available tools in dev shell:
# - nil (Nix LSP)
# - nixfmt-rfc-style (formatter)
# - nodejs-slim
# - git
# - repl (custom REPL package)
```

### Formatting and Linting
```bash
# Format all Nix files (uses nixfmt-rfc-style)
nix fmt

# The pre-commit hooks will automatically run:
# - nixfmt-rfc-style for .nix files
# - prettier for other files (excluding .js, .md, .ts)
```

### Server Deployment
For server configurations, use nixos-anywhere:
```bash
# Generate hardware configuration
nix run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-generate-config ./hosts/server/hardware-configuration.nix --flake .#server --target-host user@host

# Deploy to server
nix run github:nix-community/nixos-anywhere -- --flake .#server --target-host user@host
```

## Configuration Architecture

### Host Configurations
- **ryzen**: Desktop configuration with Hyprland, gaming, and development tools
- **server**: Minimal server configuration with Docker and Discord bot

### System Module Organization
- `system/core/` - Essential system configuration (boot, users, security)
- `system/hardware/` - Hardware-specific modules
- `system/network/` - Network services and configuration
- `system/programs/` - System-wide programs
- `system/services/` - System services

### Home Manager Structure
- `home/terminal/` - Terminal applications and shell configuration
- `home/programs/` - User programs organized by category
- `home/services/` - User services
- `home/theme/` - Theming and appearance

### Key Patterns
- Use `callPackage` pattern for custom packages in `pkgs/`
- Secrets managed with sops-nix
- Catppuccin theming applied consistently
- Hyprland as the main desktop environment
- Pre-commit hooks ensure code quality

### Common Imports
Most configurations will import from these standard locations:
- `inputs.nixpkgs.lib` for standard library functions
- `inputs.home-manager` for home manager modules
- `inputs.catppuccin` for theming
- `self.nixosModules` for custom modules

### Secret Management
Secrets are stored in YAML files encrypted with sops:
- `home/secrets.yaml` - Home Manager secrets
- `hosts/common/secrets.yaml` - Common host secrets
- `hosts/server/secrets.yaml` - Server-specific secrets

Use `nix-shell -p sops --run "sops updatekeys path/to/secrets.yaml"` to update secret keys.
