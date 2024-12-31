#!/bin/bash

set -e  # Exit on errors
set -x  # Echo each line

ARM_BIN_DIR=$HOME/tools/arm-gnu-toolchain-14.2.rel1-x86_64-arm-none-eabi/bin
COPTS="-w -g3 -nostdlib -mcpu=cortex-m4 -mfloat-abi=softfp -mfpu=fpv4-sp-d16 -Wall -Wextra -mthumb -Os"

rm -r build
mkdir -p build

${ARM_BIN_DIR}/arm-none-eabi-gcc ${COPTS} -c -o build/blink.o blink.c
${ARM_BIN_DIR}/arm-none-eabi-gcc ${COPTS} -Tlinker_script.ld -Wl,-Map,build/blink.map  -o build/blink.elf build/blink.o

${ARM_BIN_DIR}/arm-none-eabi-objcopy -O binary build/blink.elf build/blink.bin
${ARM_BIN_DIR}/arm-none-eabi-objcopy -O ihex -R .eeprom build/blink.elf build/blink.hex

if [ $# -gt 0 ]; then
    "$HOME/.arduino15/packages/arduino/tools/bossac/1.9.1-arduino2/bossac" -d --port=ttyNANO0 -U -i -e -w "build/blink.bin" -R
fi
