# Add to ~/.gdbinit:
# add-auto-load-safe-path /home/asum/dev/fw-talk/arduino-blink-raw/.gdbinit

file build/Blink.ino.elf

target extended-remote | /home/asum/.arduino15/packages/arduino/tools/openocd/0.11.0-arduino2/bin/openocd -c "gdb_port pipe" -f interface/cmsis-dap.cfg -f /home/asum/.arduino15/packages/arduino/hardware/mbed_nano/4.2.1/debugger/select_swd.cfg -f target/nrf52.cfg
