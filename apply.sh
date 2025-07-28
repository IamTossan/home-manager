#!/bin/bash

NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 home-manager switch --impure --flake .#tossan
