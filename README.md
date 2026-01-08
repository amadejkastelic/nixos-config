# NixOS & Home Manager Dotfiles

Personal NixOS and Home Manager configuration using flake-parts for a modular, reproducible system setup.

## Features

- **NixOS Configuration**: Complete system configuration for desktop and server environments
- **Home Manager Integration**: User-space configuration management
- **Hyprland Desktop**: Modern Wayland compositor with comprehensive theming
- **Catppuccin Theme**: Consistent theming across all applications
- **Gaming Setup**: Steam, GameMode, and various gaming tools
- **Development Environment**: Pre-configured editors, terminal tools, and language servers
- **Secret Management**: Encrypted secrets using sops-nix
- **Pre-commit Hooks**: Automated code formatting and linting

## Hosts

- **ryzen**: Main desktop configuration with Hyprland, gaming, and development tools
- **server**: Minimal server setup with Docker and Discord bot services

## Structure

```
├── flake.nix              # Main flake configuration
├── home/                  # Home Manager configurations
│   ├── programs/          # User programs (browsers, games, media, etc.)
│   ├── services/          # User services (notifications, media controls)
│   ├── terminal/          # Terminal apps and shell configuration
│   └── theme/             # Theming and appearance
├── hosts/                 # Host-specific configurations
│   ├── ryzen/             # Desktop configuration
│   └── server/            # Server configuration
├── system/                # NixOS system modules
│   ├── core/              # Essential system configuration
│   ├── hardware/          # Hardware-specific modules
│   ├── network/           # Network services
│   ├── programs/          # System-wide programs
│   └── services/          # System services
├── lib/                   # Custom library functions
├── modules/               # Custom NixOS/Home Manager modules
└── pkgs/                  # Custom package definitions
```

## Usage

### Building System Configuration

```bash
# Build and switch to new configuration
sudo nixos-rebuild switch --flake .#ryzen

# Test configuration without switching
sudo nixos-rebuild test --flake .#ryzen
```

### Development Environment

```bash
# Enter development shell with tools
nix develop

# Format all Nix files
nix fmt

# Build custom packages
nix build .#catppuccin-plymouth
nix build .#wl-ocr
nix build .#bibata-cursors-svg
```

## Development Tools

The development shell includes:
- **nil**: Nix language server
- **nixfmt**: Code formatter
- **git**: Version control
- **repl**: Custom REPL for configuration testing

## Theming

Consistent Catppuccin theming across:
- Window manager (Hyprland)
- Terminal applications
- GTK/Qt applications
- Web browsers
- Development tools

## Secret Management

Secrets are encrypted using sops-nix:
- `home/secrets.yaml` - Home Manager secrets
- `hosts/common/secrets.yaml` - Common host secrets
- `hosts/server/secrets.yaml` - Server-specific secrets

Update secret keys:
```bash
nix-shell -p sops --run "sops updatekeys path/to/secrets.yaml"
```

## Key Applications

### Desktop Environment
- **Hyprland**: Wayland compositor
- **Waybar**: Status bar
- **Rofi/Wofi**: Application launchers
- **Mako**: Notifications

### Development
- **Neovim**: Text editor with LSP support
- **VSCode**: IDE with extensions
- **Git**: Version control with custom configuration
- **Ghostty**: Terminal emulators

### Media & Gaming
- **Steam**: Gaming platform with Proton
- **MPV**: Media player
- **Cider**: Music streaming
- **OBS**: Screen recording

### Productivity
- **Firefox/Chromium**: Web browsers
- **Thunderbird**: Email client
- **Zathura**: PDF viewer
- **Nautilus/Thunar**: File managers

## License

This configuration is available under the terms specified in the LICENSE file.

## Contributing

This is a personal dotfiles repository, but feel free to:
- Use any parts of this configuration for your own setup
- Report issues or suggest improvements
- Submit pull requests for bug fixes

## References

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Catppuccin Theme](https://github.com/catppuccin/catppuccin)
