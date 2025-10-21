# How to use

## Bootstraping

### On non-nixos

Only a home-manager config is supported

The bootstrap steps are:

- [install nix](https://nixos.org/download/)
- if using only home-manager, configure nix to use nix-command and flakes by adding the following line in `/etc/nix/nix.conf`:
  ```
  experimental-features = nix-command flakes
  ```
- install home-manager (see [official doc](https://nix-community.github.io/home-manager/index.xhtml#ch-installation))
- source it: `source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh `
- run directly `home-manager` the first time with `~/.nix-profile/bin/home-manager switch --flake .#augustin-Oslandia --impure`

The first generation is complete. See next part for subsequent generations.

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
