# Bootstrap: Munix Distribution Scripts

This repository contains scripts and files necessary to create a functioning munix install.

## Building

Building complete Munix from scratch involves a decent amount of time and computing power, but
a build full shouldn't be necissary for most installs.

### Preparations

Git, python3 and curl are required on the host, so get those first!

Create a root dir for munix (this example uses `~/sources/munix`), clone bootstrap 
and install xbstrap (from pip)
```bash
mkdir ~/sources/munix && cd ~/sources/munix
git clone https://github.com/munix-os/bootstrap src
pip3 install xbstrap
```

Install xbps and runc
```bash
# grab the latest runc from gh, but you could also install via package manager
curl -L https://github.com/opencontainers/runc/releases/download/latest/runc.amd64 > runc
chmod +x runc

# install runc wherever you like, this example puts it in python3's bin dir
mv runc ~/.local/bin/runc

# even if you're on void linux, xbstrap needs its own copy of xbps tools
xbstrap prereqs xbps
```

### Setting up a build enviorment

First off, grab the latest glibc tarball from [here](https://voidlinux.org/download/) and extract
it to `<rootdir>/rootfs` (so `~/sources/munix/rootfs` in this guide). Finally, run the following commands...
```bash
mkdir ~/sources/munix/build && cd ~/sources/munix/build
./../src/scripts/setup-container.sh ../rootfs
```

### Building

Building is really simple, and it only involves a couple of commands
```bash
xbstrap pull-pack --all
xbstrap install --all

# these two commands install tools for local development, then build the kernel & libc from source
xbstrap download-tool-archive --build-deps-of munix --build-deps-of mlibc
xbstrap install --rebuild munix mlibc mlibc-headers
```

### Generating a image

simply run the following two scripts to create an image, and copy the rootfs over
```bash
./../src/scripts/create-image.sh
./../src/scripts/copy-image.sh
```
You now have a image `munix-os.hdd` that you can run in QEMU or copy to a USB!

### Running in QEMU

Running QEMU is a easy one-liner, run `./../src/scripts/run-vm.sh` and pass params as needed