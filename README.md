# NixOS Installation

## Prepare the installation with the following steps

```bash
# Download the NixOS configuration file and apply it
curl -o /tmp/configuration.nix https://raw.githubusercontent.com/mkuchak/nixos/main/configuration.nix && sudo mv /tmp/configuration.nix /etc/nixos/configuration.nix && sudo nixos-rebuild switch

# After that download the Fish configuration file and apply it as well
curl -o ~/.config/fish/config.fish https://raw.githubusercontent.com/mkuchak/nixos/main/config.fish && source ~/.config/fish/config.fish

# Install Sugar Git and configure Git
bash <(curl -Ls raw.githubusercontent.com/mkuchak/sugar-git/main/setup)
```

## Useful commands

```bash
# Rebuild NixOS configuration and switch to the new generation
sudo nixos-rebuild switch

# Remove old generations and free up disk space
sudo nix-collect-garbage

# Update the NixOS or Fish configuration according this repository
nix-update
fish-update

# Join commit messages
git reset $(git commit-tree HEAD^{tree} -m "initial commit") && git push origin main --force
```
