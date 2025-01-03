define flash
  monitor init
  monitor reset init
  monitor adapter speed 10000
  monitor program target/thumbv7m-none-eabi/debug/nano-rust
  monitor reset run
end

target extended-remote | \
  /home/asum/.arduino15/packages/arduino/tools/openocd/0.11.0-arduino2/bin/openocd -c "gdb_port pipe" -f openocd.cfg

set print asm-demangle on
set backtrace limit 32

break DefaultHandler
break HardFault
break rust_begin_unwind
break main

monitor arm semihosting enable

load

stepi
