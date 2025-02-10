# home-manager

## Installation

- install nix

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sudo sh -s -- install
```

```bash
sudo mkdir -m 0755 -p /nix/var/nix/{profiles,gcroots}/per-user/$USER
sudo chown -R $USER:nixbld /nix/var/nix/{profiles,gcroots}/per-user/$USER
```

- install home-manager [here](https://nix-community.github.io/home-manager/index.xhtml#ch-installation)

- install nixgl [here](https://github.com/nix-community/nixGL)

- activate profile

```bash
home-manager switch --impure --flake .#tossan
```

## Notes

- update package cache
```bash
nix flake update
```
