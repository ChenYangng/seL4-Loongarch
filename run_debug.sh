#!/bin/bash

############################################################
# Help                                                     #
############################################################
Help()
{
   # Display Help
   echo "Run qemu and gdb to help debug. \
   	You should add sel4test and qemu-loongarch-runenv to path. \
   	You can save breakpoints to la.bp or rv.bp, gdb will load the breakpoints you saved next time."
   echo
   echo "Syntax: run_debug.sh [-l|r|h]"
   echo "options:"
   echo "l to debug kernel of loongarch architecture"
   echo "r to debug kernel of riscv architecture"
   echo "a to debug kernel of arm architecture"
   echo "h help"
}

# For example: add these variables to your path.
SEL4_TEST=$(realpath $(dirname $0))
QEMU_LA_RUNENV=$(realpath $(dirname $0))/tools/qemu-loongarch-runenv
# Get the options
while getopts ":lrah" option;
do
   case $option in
   	l)
   	   gnome-terminal -t "gdb loongarch kernel with breakpoints: ./la.bp" \
   	   -- sh -c "echo using port 1122, you could save your breakpoints as ./la.bp;\
   	   loongarch64-unknown-linux-gnu-gdb build-3A5000/kernel/kernel.elf \
   	   -ex 'add-symbol-file build-3A5000/elfloader/elfloader' \
   	   -ex 'add-symbol-file build-3A5000/apps/sel4test-driver/sel4test-driver' \
   	   -ex 'add-symbol-file build-3A5000/apps/sel4test-driver/sel4test-tests/sel4test-tests' \
   	   -ex 'set output-radix 16' \
   	   -ex 'target remote:1234'; \
       -ex 'source la.pb'; \
   	   exec bash;"
   	   gnome-terminal -t "qemu-system-loongarch64 simulator" \
   	   -- sh -x -c "cd ${QEMU_LA_RUNENV};\
   	   bash run_loongarch.sh -k ${SEL4_TEST}/build-3A5000/images/sel4test-driver-image-loongarch-3A5000 -D | tee ${SEL4_TEST}lalog.txt;\
   	   exec bash;"
   	   ;;
   	r)
   	   gnome-terminal -t "gdb riscv kernel with breakpoints: ./rv.bp" \
   	   -- sh -c "echo using port 1234, you could save your breakpoints as ./rv.bp;\
   	   riscv64-unknown-linux-gnu-gdb build-spike/kernel/kernel.elf \
   	   -ex 'add-symbol-file build-spike/elfloader/elfloader' \
   	   -ex 'add-symbol-file build-spike/apps/sel4test-driver/sel4test-driver' \
   	   -ex 'add-symbol-file build-spike/apps/sel4test-driver/sel4test-tests/sel4test-tests' \
   	   -ex 'set output-radix 16' \
   	   -ex 'target remote:1234'; \
   	   -ex 'source rv.bp'; \
   	   exec bash;"
   	   gnome-terminal -t "qemu-system-riscv64 simulator" \
   	   -- sh -c "cd build-spike/images;\
   	   set -x;\
   	   qemu-system-riscv64 -machine spike -cpu rv64 -nographic -serial mon:stdio -m size=4095M -S -s -kernel sel4test-driver-image-riscv-spike -bios none | tee ${SEL4_TEST}rvlog.txt;set +x;\
   	   exec bash;"
   	   ;;
   	a)
   	   gnome-terminal -t "gdb arm kernel with breakpoints: ./am.bp" \
   	   -- sh -c "echo using port 1100, you could save your breakpoints as ./am.bp;\
   	   gdb-multiarch build-rpi/kernel/kernel.elf \
   	   -ex 'add-symbol-file build-rpi/elfloader/elfloader' \
   	   -ex 'add-symbol-file build-rpi/apps/sel4test-driver/sel4test-driver' \
   	   -ex 'add-symbol-file build-rpi/apps/sel4test-driver/sel4test-tests/sel4test-tests' \
   	   -ex 'set output-radix 16' \
   	   -ex 'target remote:1100'; \
   	   -ex 'source am.bp'; \
   	   exec bash;"
   	   gnome-terminal -t "qemu-system-aarch64 simulator" \
   	   -- sh -c "cd build-rpi/images;\
   	   set -x;\
   	   qemu-system-aarch64 -machine raspi3b -nographic -serial null -serial mon:stdio -gdb tcp::1100 -m size=1024M -S -kernel sel4test-driver-image-arm-bcm2837;set +x;exec bash;"
   	   ;;
   	h)
   	   Help
   	   exit
       ;;
   	\?)
   	   echo "invalid option"
   	   exit
       ;;
    esac
done

cd ${SEL4_TEST};

