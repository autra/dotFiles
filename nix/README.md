# How to use

## Bootstraping

### On non-nixos

Only a home-manager config is supported

The steps are:

- [install nix](https://nixos.org/download/)
- if using only home-manager, configure nix to use nix-command and flakes by adding the following line in `/etc/nix/nix.conf`:
  ```
  experimental-features = nix-command flakes
  ```
- install home-manager (see [official doc](https://nix-community.github.io/home-manager/index.xhtml#ch-installation))
- see next part for next iterations

## Daily usage

I use [nh](https://github.com/viperML/nh) but nixos-rebuild direct use is of course totally possible.

To rebuild my system

```sh
nh os switch -a -- --cores 2 --max-jobs 3
```

To rebuild home env:

```sh
nh home switch -a -b backup -- --impure
```

To build my pi image:

```sh
nix build .#images.pi 
```
