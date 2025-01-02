# Add to ~/.gdbinit:

file build/blink.elf

target extended-remote | /home/asum/.arduino15/packages/arduino/tools/openocd/0.11.0-arduino2/bin/openocd -c "gdb_port pipe" -f interface/cmsis-dap.cfg -f $HOME/.arduino15/packages/arduino/hardware/mbed_nano/4.2.1/debugger/select_swd.cfg -f target/nrf52.cfg

define flash-blink
  monitor init
  monitor reset init
  monitor adapter speed 10000
  monitor program build/blink.hex
  monitor reset run
end

define flash-blink-nobl
  monitor init
  monitor reset init
  monitor adapter speed 10000
  monitor program build/blink_nobl.hex
  monitor reset run
end

define flash-bl
  monitor init
  monitor reset init
  monitor adapter speed 10000
  monitor program /home/asum/.arduino15/packages/arduino/hardware/mbed_nano/4.2.1/bootloaders/nano33ble/bootloader.hex
  monitor reset run
end
