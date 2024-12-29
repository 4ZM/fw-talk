#!/bin/bash

set -e  # Exit on errors
set -x  # Echo each line

#ARM_BIN_DIR=/home/asum/.arduino15/packages/arduino/tools/arm-none-eabi-gcc/7-2017q4/bin
ARM_BIN_DIR=/home/asum/tools/arm-gnu-toolchain-14.2.rel1-x86_64-arm-none-eabi/bin
PROJ_DIR=/home/asum/dev/fw-talk/arduino-blink-raw
MBED_DIR=/home/asum/.arduino15/packages/arduino/hardware/mbed_nano/4.2.1
MBED_CPP_OPTS="@${MBED_DIR}/variants/ARDUINO_NANO33BLE/defines.txt \
           @${MBED_DIR}/variants/ARDUINO_NANO33BLE/cxxflags.txt \
           -I${MBED_DIR}/cores/arduino \
           -I${MBED_DIR}/variants/ARDUINO_NANO33BLE \
           -I${MBED_DIR}/cores/arduino/api/deprecated \
           -I${MBED_DIR}/cores/arduino/api/deprecated-avr-comp \
           -iprefix${MBED_DIR}/cores/arduino \
           @${MBED_DIR}/variants/ARDUINO_NANO33BLE/includes.txt"


MBED_C_OPTS="@${MBED_DIR}/variants/ARDUINO_NANO33BLE/defines.txt \
             @${MBED_DIR}/variants/ARDUINO_NANO33BLE/cflags.txt \
             -I${MBED_DIR}/cores/arduino/api/deprecated \
             -I${MBED_DIR}/cores/arduino/api/deprecated-avr-comp \
             -I${MBED_DIR}/cores/arduino \
             -I${MBED_DIR}/variants/ARDUINO_NANO33BLE \
             -iprefix${MBED_DIR}/cores/arduino \
             @${MBED_DIR}/variants/ARDUINO_NANO33BLE/includes.txt"

DEFINES="-DARDUINO_ARCH_NRF52840 -DARDUINO=10607 -DARDUINO_ARDUINO_NANO33BLE -DARDUINO_ARCH_MBED_NANO -DARDUINO_ARCH_MBED -DARDUINO_LIBRARY_DISCOVERY_PHASE=0"
COPTS="-w -g3 -nostdlib -MMD -mcpu=cortex-m4 -mfloat-abi=softfp -mfpu=fpv4-sp-d16"

mkdir -p ${PROJ_DIR}/core/{USB,api,as_mbed_library,arduino,mbed/platform/cxxsupport}
mkdir -p ${PROJ_DIR}/build


${ARM_BIN_DIR}/arm-none-eabi-g++ -c  ${MBED_CPP_OPTS} ${DEFINES} ${COPTS}   ${MBED_DIR}/variants/ARDUINO_NANO33BLE/variant.cpp -o ${PROJ_DIR}/core/variant.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-g++ -c  ${MBED_CPP_OPTS} ${DEFINES} ${COPTS}   ${MBED_DIR}/cores/arduino/Interrupts.cpp -o ${PROJ_DIR}/core/Interrupts.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-g++ -c  ${MBED_CPP_OPTS} ${DEFINES} ${COPTS}   ${MBED_DIR}/cores/arduino/USB/USBCDC.cpp -o ${PROJ_DIR}/core/USB/USBCDC.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-g++ -c  ${MBED_CPP_OPTS} ${DEFINES} ${COPTS}   ${MBED_DIR}/cores/arduino/Tone.cpp -o ${PROJ_DIR}/core/Tone.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-g++ -c  ${MBED_CPP_OPTS} ${DEFINES} ${COPTS}   ${MBED_DIR}/cores/arduino/USB/PluggableUSBDevice.cpp -o ${PROJ_DIR}/core/USB/PluggableUSBDevice.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-g++ -c  ${MBED_CPP_OPTS} ${DEFINES} ${COPTS}   ${MBED_DIR}/cores/arduino/main.cpp -o ${PROJ_DIR}/core/main.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-g++ -c  ${MBED_CPP_OPTS} ${DEFINES} ${COPTS}   ${MBED_DIR}/cores/arduino/Serial.cpp -o ${PROJ_DIR}/core/Serial.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-g++ -c  ${MBED_CPP_OPTS} ${DEFINES} ${COPTS}   ${MBED_DIR}/cores/arduino/api/IPAddress.cpp -o ${PROJ_DIR}/core/api/IPAddress.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-g++ -c  ${MBED_CPP_OPTS} ${DEFINES} ${COPTS}   ${MBED_DIR}/cores/arduino/api/String.cpp -o ${PROJ_DIR}/core/api/String.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-g++ -c  ${MBED_CPP_OPTS} ${DEFINES} ${COPTS}   ${MBED_DIR}/cores/arduino/api/PluggableUSB.cpp -o ${PROJ_DIR}/core/api/PluggableUSB.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-g++ -c  ${MBED_CPP_OPTS} ${DEFINES} ${COPTS}   ${MBED_DIR}/cores/arduino/api/Stream.cpp -o ${PROJ_DIR}/core/api/Stream.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-g++ -c  ${MBED_CPP_OPTS} ${DEFINES} ${COPTS}   ${MBED_DIR}/cores/arduino/api/Print.cpp -o ${PROJ_DIR}/core/api/Print.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-g++ -c  ${MBED_CPP_OPTS} ${DEFINES} ${COPTS}   ${MBED_DIR}/cores/arduino/USB/USBSerial.cpp -o ${PROJ_DIR}/core/USB/USBSerial.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-g++ -c  ${MBED_CPP_OPTS} ${DEFINES} ${COPTS}   ${MBED_DIR}/cores/arduino/api/CanMsgRingbuffer.cpp -o ${PROJ_DIR}/core/api/CanMsgRingbuffer.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-g++ -c  ${MBED_CPP_OPTS} ${DEFINES} ${COPTS}   ${MBED_DIR}/cores/arduino/api/Common.cpp -o ${PROJ_DIR}/core/api/Common.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-g++ -c  ${MBED_CPP_OPTS} ${DEFINES} ${COPTS}   ${MBED_DIR}/cores/arduino/api/CanMsg.cpp -o ${PROJ_DIR}/core/api/CanMsg.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-g++ -c  ${MBED_CPP_OPTS} ${DEFINES} ${COPTS}   ${MBED_DIR}/cores/arduino/as_mbed_library/variant.cpp -o ${PROJ_DIR}/core/as_mbed_library/variant.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-g++ -c  ${MBED_CPP_OPTS} ${DEFINES} ${COPTS}   ${MBED_DIR}/cores/arduino/abi.cpp -o ${PROJ_DIR}/core/abi.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-g++ -c  ${MBED_CPP_OPTS} ${DEFINES} ${COPTS}   ${MBED_DIR}/cores/arduino/WMath.cpp -o ${PROJ_DIR}/core/WMath.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-g++ -c  ${MBED_CPP_OPTS} ${DEFINES} ${COPTS}   ${MBED_DIR}/cores/arduino/mbed/platform/cxxsupport/mstd_mutex.cpp -o ${PROJ_DIR}/core/mbed/platform/cxxsupport/mstd_mutex.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-g++ -c  ${MBED_CPP_OPTS} ${DEFINES} ${COPTS}   ${MBED_DIR}/cores/arduino/pinToIndex.cpp -o ${PROJ_DIR}/core/pinToIndex.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-g++ -c  ${MBED_CPP_OPTS} ${DEFINES} ${COPTS}   ${MBED_DIR}/cores/arduino/random_seed.cpp -o ${PROJ_DIR}/core/random_seed.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-g++ -c  ${MBED_CPP_OPTS} ${DEFINES} ${COPTS}   ${MBED_DIR}/cores/arduino/timer.cpp -o ${PROJ_DIR}/core/timer.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-g++ -c  ${MBED_CPP_OPTS} ${DEFINES} ${COPTS}   ${MBED_DIR}/cores/arduino/wiring.cpp -o ${PROJ_DIR}/core/wiring.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-g++ -c  ${MBED_CPP_OPTS} ${DEFINES} ${COPTS}   ${MBED_DIR}/cores/arduino/wiring_analog.cpp -o ${PROJ_DIR}/core/wiring_analog.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-g++ -c  ${MBED_CPP_OPTS} ${DEFINES} ${COPTS}   ${MBED_DIR}/cores/arduino/wiring_digital.cpp -o ${PROJ_DIR}/core/wiring_digital.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-g++ -c  ${MBED_CPP_OPTS} ${DEFINES} ${COPTS}   ${MBED_DIR}/cores/arduino/wiring_pulse.cpp -o ${PROJ_DIR}/core/wiring_pulse.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-g++ -c  ${MBED_CPP_OPTS} ${DEFINES} ${COPTS}   ${MBED_DIR}/cores/arduino/wiring_shift.cpp -o ${PROJ_DIR}/core/wiring_shift.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-gcc -c  ${MBED_C_OPTS} ${DEFINES} ${COPTS}  -o ${PROJ_DIR}/core/arm_hal_random.c.o ${MBED_DIR}/cores/arduino/arm_hal_random.c
${ARM_BIN_DIR}/arm-none-eabi-gcc -c  ${MBED_C_OPTS} ${DEFINES} ${COPTS}  -o ${PROJ_DIR}/core/itoa.c.o ${MBED_DIR}/cores/arduino/itoa.c
${ARM_BIN_DIR}/arm-none-eabi-ar rcs ${PROJ_DIR}/core/core.a ${PROJ_DIR}/core/Interrupts.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-ar rcs ${PROJ_DIR}/core/core.a ${PROJ_DIR}/core/Serial.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-ar rcs ${PROJ_DIR}/core/core.a ${PROJ_DIR}/core/Tone.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-ar rcs ${PROJ_DIR}/core/core.a ${PROJ_DIR}/core/USB/PluggableUSBDevice.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-ar rcs ${PROJ_DIR}/core/core.a ${PROJ_DIR}/core/USB/USBCDC.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-ar rcs ${PROJ_DIR}/core/core.a ${PROJ_DIR}/core/USB/USBSerial.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-ar rcs ${PROJ_DIR}/core/core.a ${PROJ_DIR}/core/WMath.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-ar rcs ${PROJ_DIR}/core/core.a ${PROJ_DIR}/core/abi.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-ar rcs ${PROJ_DIR}/core/core.a ${PROJ_DIR}/core/api/CanMsg.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-ar rcs ${PROJ_DIR}/core/core.a ${PROJ_DIR}/core/api/CanMsgRingbuffer.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-ar rcs ${PROJ_DIR}/core/core.a ${PROJ_DIR}/core/api/Common.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-ar rcs ${PROJ_DIR}/core/core.a ${PROJ_DIR}/core/api/IPAddress.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-ar rcs ${PROJ_DIR}/core/core.a ${PROJ_DIR}/core/api/PluggableUSB.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-ar rcs ${PROJ_DIR}/core/core.a ${PROJ_DIR}/core/api/Print.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-ar rcs ${PROJ_DIR}/core/core.a ${PROJ_DIR}/core/api/Stream.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-ar rcs ${PROJ_DIR}/core/core.a ${PROJ_DIR}/core/api/String.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-ar rcs ${PROJ_DIR}/core/core.a ${PROJ_DIR}/core/arm_hal_random.c.o
${ARM_BIN_DIR}/arm-none-eabi-ar rcs ${PROJ_DIR}/core/core.a ${PROJ_DIR}/core/as_mbed_library/variant.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-ar rcs ${PROJ_DIR}/core/core.a ${PROJ_DIR}/core/itoa.c.o
${ARM_BIN_DIR}/arm-none-eabi-ar rcs ${PROJ_DIR}/core/core.a ${PROJ_DIR}/core/main.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-ar rcs ${PROJ_DIR}/core/core.a ${PROJ_DIR}/core/mbed/platform/cxxsupport/mstd_mutex.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-ar rcs ${PROJ_DIR}/core/core.a ${PROJ_DIR}/core/pinToIndex.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-ar rcs ${PROJ_DIR}/core/core.a ${PROJ_DIR}/core/random_seed.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-ar rcs ${PROJ_DIR}/core/core.a ${PROJ_DIR}/core/timer.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-ar rcs ${PROJ_DIR}/core/core.a ${PROJ_DIR}/core/wiring.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-ar rcs ${PROJ_DIR}/core/core.a ${PROJ_DIR}/core/wiring_analog.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-ar rcs ${PROJ_DIR}/core/core.a ${PROJ_DIR}/core/wiring_digital.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-ar rcs ${PROJ_DIR}/core/core.a ${PROJ_DIR}/core/wiring_pulse.cpp.o
${ARM_BIN_DIR}/arm-none-eabi-ar rcs ${PROJ_DIR}/core/core.a ${PROJ_DIR}/core/wiring_shift.cpp.o

${ARM_BIN_DIR}/arm-none-eabi-g++ -c  ${MBED_CPP_OPTS} ${DEFINES} ${COPTS}  ${PROJ_DIR}/Blink.ino.cpp -o ${PROJ_DIR}/build/Blink.ino.cpp.o

# Just a copy - preprocessor doesn't do anything
${ARM_BIN_DIR}/arm-none-eabi-g++ -E -P -x c ${MBED_DIR}/variants/ARDUINO_NANO33BLE/linker_script.ld -o ${PROJ_DIR}/build/linker_script.ld

${ARM_BIN_DIR}/arm-none-eabi-g++ -L${PROJ_DIR} -Wl,--gc-sections -w -Wl,--as-needed @${MBED_DIR}/variants/ARDUINO_NANO33BLE/ldflags.txt -T${PROJ_DIR}/build/linker_script.ld -Wl,-Map,${PROJ_DIR}/build/Blink.ino.map --specs=nosys.specs -o ${PROJ_DIR}/build/Blink.ino.elf ${PROJ_DIR}/build/Blink.ino.cpp.o ${PROJ_DIR}/core/variant.cpp.o -Wl,--whole-archive ${PROJ_DIR}/core/core.a ${MBED_DIR}/variants/ARDUINO_NANO33BLE/libs/libmbed.a ${MBED_DIR}/variants/ARDUINO_NANO33BLE/libs/libcc_310_core.a ${MBED_DIR}/variants/ARDUINO_NANO33BLE/libs/libcc_310_ext.a ${MBED_DIR}/variants/ARDUINO_NANO33BLE/libs/libcc_310_trng.a -Wl,--no-whole-archive -Wl,--start-group -lstdc++ -lsupc++ -lm -lc -lgcc -lnosys -Wl,--end-group
${ARM_BIN_DIR}/arm-none-eabi-objcopy -O binary ${PROJ_DIR}/build/Blink.ino.elf ${PROJ_DIR}/build/Blink.ino.bin
${ARM_BIN_DIR}/arm-none-eabi-objcopy -O ihex -R .eeprom ${PROJ_DIR}/build/Blink.ino.elf ${PROJ_DIR}/build/Blink.ino.hex

${ARM_BIN_DIR}/arm-none-eabi-size -A ${PROJ_DIR}/build/Blink.ino.elf

"/home/asum/.arduino15/packages/arduino/tools/bossac/1.9.1-arduino2/bossac" -d --port=ttyACM0 -U -i -e -w "${PROJ_DIR}/build/Blink.ino.bin" -R
