# Server Configuration

To install on a server, run the following commands:

### x86_64

- Update hardware-configuration:
```bash
nix run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-generate-config ./hosts/server/hardware-configuration.nix --flake .#server --target-host user@host
```
- Install:
```bash
nix run github:nix-community/nixos-anywhere -- --flake .#server --target-host user@host
```
- Get age key:
```bash
nix-shell -p ssh-to-age --run "cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age"
```
- Update secrets:
```bash
nix-shell -p sops --run "sops updatekeys hosts/common/secrets.yaml"
nix-shell -p sops --run "sops updatekeys hosts/server/secrets.yaml"
```

### aarch64

- Install and update hardware-configuration:
```bash
nix run github:numtide/nixos-anywhere -- --generate-hardware-config nixos-generate-config ./hosts/server/hardware-configuration.nix --flake .#server user@host --kexec "$(nix build --print-out-paths github:nix-community/nixos-images#packages.aarch64-linux.kexec-installer-nixos-unstable-noninteractive)/nixos-kexec-installer-noninteractive-aarch64-linux.tar.gz"
```
