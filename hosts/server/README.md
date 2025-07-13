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
- Update secrets:
```bash
nix-shell -p sops --run "sops updatekeys hosts/server/example.yaml"
```
