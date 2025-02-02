#!/bin/sh
git stage *
git commit -m "$(date)"
sudo nixos-rebuild switch --flake ./ $1
