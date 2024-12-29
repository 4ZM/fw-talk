#!/bin/bash

# RELATIVE FILES - relative
# /home/asum/.arduino15/packages/arduino/tools/openocd/0.11.0-arduino2/share/openocd/scripts/

# ONLY NEEDED FOR VS? -f /home/asum/bin/arduino-ide-2.3.4/resources/app/plugins/cortex-debug/extension/support/openocd-helpers.tcl \

/home/asum/.arduino15/packages/arduino/tools/openocd/0.11.0-arduino2/bin/openocd \
    -c "gdb_port 50000" -c "tcl_port 50001" -c "telnet_port 50002" \
    -f interface/cmsis-dap.cfg \
    -f /home/asum/.arduino15/packages/arduino/hardware/mbed_nano/4.2.1/debugger/select_swd.cfg \
    -f target/nrf52.cfg
