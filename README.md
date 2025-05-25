# My dotfiles 

This directory contains the dotfiles for my system 

## Requirements

Ensure you have the following installed on your system

### Git 

```
pacman -S git
```

### Stow
```
pacman -S stow
```

## Installation

1. Check out the dotfiles repo in you $HOME dir using git 
```
$ git clone git@github.com/CarstenOtl/dotfiles_endeavor_1.git
$ cd dotfiles_endeavor_1
```

then use GNU stow to create symlinks

```
$ stow .
```

### TODO
- [] fix dunst 
- [] implement notification center using dunst
- [] power profile daemon for nvidia? or with nvidia?


