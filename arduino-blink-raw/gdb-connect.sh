#!/bin/bash

ARM_BIN_DIR=/home/asum/.arduino15/packages/arduino/tools/arm-none-eabi-gcc/7-2017q4/bin
PROJ_DIR=/home/asum/dev/fw-talk/arduino-blink-raw

# ${ARM_BIN_DIR}/arm-none-eabi-objdump --syms -C -h -w ${PROJ_DIR}/build/Blink.ino.elf
# ${ARM_BIN_DIR}/arm-none-eabi-nm --defined-only -S -l -C -p ${PROJ_DIR}/build/Blink.ino.elf

${ARM_BIN_DIR}/arm-none-eabi-gdb ${PROJ_DIR}/build/Blink.ino.elf
