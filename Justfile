host := `hostname`

update:
    nix flake update --commit-lock-file

# https://nixpkgs-tracker.ocfox.me/?pr=494720
upgrade TARGET=host:
    #!/usr/bin/env bash
    if [ "{{TARGET}}" = "{{host}}" ]; then
        nixos-rebuild switch \
            --flake .#{{TARGET}} \
            --sudo
    else
        nixos-rebuild switch \
            --flake .#{{TARGET}} \
            --target-host amadejk@{{TARGET}} \
            --sudo
    fi

gc FLAGS='':
    nix-collect-garbage {{FLAGS}}
