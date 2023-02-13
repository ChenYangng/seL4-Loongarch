# seL4 on Loongarch

## Hardware and Target Platform
Except as stated on the [Hardware](https://docs.sel4.systems/Hardware) pages, we add support for Loongarch platforms and currently support 3A5000.

## supported project
- [seL4test](https://github.com/ChenYangng/sel4test-manifest)
Running successfully on Loongson 3A5000 platform and passing all 112 test suits.

## Set up your machine
Read the official [Host Dependencies](https://docs.sel4.systems/projects/buildsystem/host-dependencies.html) page to find instructions on how to set up your host machine.In addition, we need the [environment for running Loongarch bios and OS on x86 machines](https://github.com/foxsen/qemu-loongarch-runenv).
Now you can obtain and manage seL4 project source using Google's repo tool,then build and debug.

## Build
### obtain the source
```
mkdir sel4test
cd sel4test
repo init -u https://github.com/chenyangng/sel4test-manifest.git -b loongarch
repo sync
```
### compile and build
```
./build.sh -l
```
### run and debug
```
./run_debug.sh -l
```

## Maintained repositories(Continuously expanding)
- [seL4](https://github.com/ChenYangng/seL4)
- [seL4_tools](https://github.com/ChenYangng/seL4_tools)
- [sel4test](https://github.com/ChenYangng/sel4test)
- [sel4runtime](https://github.com/ChenYangng/sel4runtime)
- [seL4_libs](https://github.com/ChenYangng/seL4_libs)
- [util_libs](https://github.com/ChenYangng/util_libs)
- [musllibc](https://github.com/ChenYangng/musllibc)
- [sel4test-manifest](https://github.com/ChenYangng/sel4test-manifest)

loongarch branch of all repositories above

## The next step
- Merge with upstream code
- Docker for building seL4 and CI infrastructure
- Add virtualization support
- Implement [Time Protection](https://trustworthy.systems/projects/TS/timeprotection/)
- Add [Mixed-criticality support](https://trustworthy.systems/projects/TS/realtime)
- Design and implementation of general-purpose operating systems based on seL4

There must be more...
