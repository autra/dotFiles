# How to use

I use [nh](https://github.com/viperML/nh)

To rebuild system

```sh
nh os switch -a -- --cores 2 --max-jobs 3
```

To rebuild home env:

```sh
nh home switch -a -b backup -- --impure
```

## With flake

nixos-rebuild --flake .#
