# Add to ~/.gdbinit:

file build/blink.elf

target extended-remote | /home/asum/.arduino15/packages/arduino/tools/openocd/0.11.0-arduino2/bin/openocd -c "gdb_port pipe" -f interface/cmsis-dap.cfg -f $HOME/.arduino15/packages/arduino/hardware/mbed_nano/4.2.1/debugger/select_swd.cfg -f target/nrf52.cfg
