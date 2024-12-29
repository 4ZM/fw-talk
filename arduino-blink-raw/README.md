# log

Raspberry Pi Debug Probe CMSIS-DAP (for use with OpenOCD)
https://www.raspberrypi.com/documentation/microcontrollers/debug-probe.html

File -> Examples -> Basic -> Blink

Connected debug probe and board (probe first for /tty/ACM0)?

First did strace to get all execve call to the arm-none-eabi-XXX toolchain tools. Server so follow sub processes. Messy.

```
execve("/home/asum/.arduino15/packages/arduino/tools/arm-none-eabi-gcc/7-2017q4/bin/arm-none-eabi-g++", ["/home/asum/.arduino15/packages/arduino/tools/arm-none-eabi-gcc/7-2017q4/bin/arm-none-eabi-g++", "-c", "-w", "-g3", "-nostdlib", "@/home/asum/.arduino15/packages/arduino/hardware/mbed_nano/4.2.1/variants/ARDUINO_NANO33BLE/defines.txt", "@/home/asum/.arduino15/packages/arduino/hardware/mbed_nano/4.2.1/variants/ARDUINO_NANO33BLE/cxxflags.txt", "-DARDUINO_ARCH_NRF52840", "-mcpu=cortex-m4", "-mfloat-abi=softfp", "-mfpu=fpv4-sp-d16", "-w", "-x", "c++", "-E", "-CC", "-DARDUINO=10607", "-DARDUINO_ARDUINO_NANO33BLE", "-DARDUINO_ARCH_MBED_NANO", "-DARDUINO_ARCH_MBED", "-DARDUINO_LIBRARY_DISCOVERY_PHASE=1", "-I/home/asum/.arduino15/packages/arduino/hardware/mbed_nano/4.2.1/cores/arduino", "-I/home/asum/.arduino15/packages/arduino/hardware/mbed_nano/4.2.1/variants/ARDUINO_NANO33BLE", "-I/home/asum/.arduino15/packages/arduino/hardware/mbed_nano/4.2.1/cores/arduino/api/deprecated", "-I/home/asum/.arduino15/packages/arduino/hardware/mbed_nano/4.2.1/cores/arduino/api/deprecated-avr-comp", "-iprefix/home/asum/.arduino15/packages/arduino/hardware/mbed_nano/4.2.1/cores/arduino", "@/home/asum/.arduino15/packages/arduino/hardware/mbed_nano/4.2.1/variants/ARDUINO_NANO33BLE/includes.txt", "/tmp/arduino-language-server3333997343/fullbuild/sketch/test-blink.ino.cpp", "-o", "/dev/null"], 0xc0001a2008 /* 87 vars */) = 0
```

File -> Preferences... -> "Show verbose output during" [x] complile [x] upload

Build and upload produced: raw-build-output.txt

Cleanup to: build.sh (just factor out common parts).

Everything is bundled inside arduino:
* arduino/tools/arm-none-eabi-gcc/7-2017q4/bin/arm-none-eabi-g++ etc.
* arduino/hardware/mbed_nano/4.2.1
* arduino/tools/bossac/1.9.1-arduino2/bossac
* arduino/tools/openocd/0.11.0-arduino2/bin/openocd

Using default bossac and openocd did not work out of the box.

! Based on arms mbed RTOS with some nano additions? mbed_nano/4.2.1

? Possibly support in mbed CE now? https://forums.mbed.com/t/mbed-ce-official-support-for-arduino-nano-33-ble/18400
? https://github.com/mbed-ce community effort for eol mbed

Programming works only in bootloader mode (double tap reset swithch) - to do with the tty?

Debugging with arduino gdb doesn't work, but regular arm toolchain works fine.

In fact using regular arm toolchain for building everything works fine. Let's do that.

Use .gdbinit for debugging and pipe for gdb <-> openocd connection (add add-auto-load-safe-path /home/asum/dev/fw-talk/arduino-blink-raw/.gdbinit to ~/.gdbinit)

Main app: Blink.ino.cpp

Linkerscript is copy from ${MBED_DIR}/variants/ARDUINO_NANO33BLE/linker_script.ld



# Backup
https://openocd.org/doc/html/Flash-Commands.html

in gdb:

monitor flash read_bank 0 bank0
monitor flash verify_bank 0 bank0


Bricked, but Arduino Tools -> Burn Bootloadedr worked

"/home/asum/.arduino15/packages/arduino/tools/openocd/0.11.0-arduino2/bin/openocd" \
    -d2 -s "/home/asum/.arduino15/packages/arduino/tools/openocd/0.11.0-arduino2/share/openocd/scripts/" \
    -f interface/cmsis-dap.cfg -f /home/asum/.arduino15/packages/arduino/hardware/mbed_nano/4.2.1/debugger/select_swd.cfg \
    -f target/nrf52.cfg \
    -c "telnet_port disabled; init; reset init; halt; adapter speed 10000; echo INFO:removed_mass-erase; \
        program {/home/asum/.arduino15/packages/arduino/hardware/mbed_nano/4.2.1/bootloaders/nano33ble/bootloader.hex}; \
        reset run; shutdown"

This also seems to work gdb monitor:

init
reset init
halt
monitor program build/Blink.ino.hex
reset run



# Build options

Interesting data from arduino/hardware/mbed_nano/4.2.1/variants/ARDUINO_NANO33BLE/pins_arduino.h

  32   │ // Frequency of the board main oscillator
  33   │ #define VARIANT_MAINOSC (32768ul)
  34   │
  35   │ // Master clock frequency
  36   │ #define VARIANT_MCK     (64000000ul)
...
  52   │ // LEDs
  53   │ // ----
  54   │ #define PIN_LED     (13u)
  55   │ #define LED_BUILTIN PIN_LED
  56   │ #define LEDR        (22u)
  57   │ #define LEDG        (23u)
  58   │ #define LEDB        (24u)
  59   │ #define LED_PWR     (25u)

Interesting build options

       │ File: /home/asum/.arduino15/packages/arduino/hardware/mbed_nano/4.2.1/variants/ARDUINO_NANO33BLE/cflags.txt
───────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1   │ -c
   2   │ -std=gnu11
   3   │ -DAPPLICATION_ADDR=0x10000
   4   │ -DAPPLICATION_SIZE=0xf0000
   5   │ -DMBED_RAM_SIZE=0x40000
   6   │ -DMBED_RAM_START=0x20000000
   7   │ -DMBED_ROM_SIZE=0x100000
   8   │ -DMBED_ROM_START=0x0
   9   │ -DMBED_TRAP_ERRORS_ENABLED=1
  10   │ -Os
  11   │ -Wall
  12   │ -Wextra
  13   │ -Wno-missing-field-initializers
  14   │ -Wno-unused-parameter
  15   │ -fdata-sections
  16   │ -ffunction-sections
  17   │ -fmessage-length=0
  18   │ -fno-exceptions
  19   │ -fomit-frame-pointer
  20   │ -funsigned-char
  21   │ -mcpu=cortex-m4
  22   │ -mfloat-abi=softfp
  23   │ -mfpu=fpv4-sp-d16
  24   │ -mthumb


       │ File: /home/asum/.arduino15/packages/arduino/hardware/mbed_nano/4.2.1/variants/ARDUINO_NANO33BLE/cxxflags.txt
───────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1   │ -Wvla
   2   │ -c
   3   │ -fno-rtti
   4   │ -std=gnu++14
   5   │ -DAPPLICATION_ADDR=0x10000
   6   │ -DAPPLICATION_SIZE=0xf0000
   7   │ -DMBED_RAM_SIZE=0x40000
   8   │ -DMBED_RAM_START=0x20000000
   9   │ -DMBED_ROM_SIZE=0x100000
  10   │ -DMBED_ROM_START=0x0
  11   │ -DMBED_TRAP_ERRORS_ENABLED=1
  12   │ -Os
  13   │ -Wall
  14   │ -Wextra
  15   │ -Wno-missing-field-initializers
  16   │ -Wno-unused-parameter
  17   │ -fdata-sections
  18   │ -ffunction-sections
  19   │ -fmessage-length=0
  20   │ -fno-exceptions
  21   │ -fomit-frame-pointer
  22   │ -funsigned-char
  23   │ -mcpu=cortex-m4
  24   │ -mfloat-abi=softfp
  25   │ -mfpu=fpv4-sp-d16
  26   │ -mthumb

       │ File: /home/asum/.arduino15/packages/arduino/hardware/mbed_nano/4.2.1/variants/ARDUINO_NANO33BLE/ldflags.txt
───────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1   │ -DMBED_APP_SIZE=0xf0000
   2   │ -DMBED_APP_START=0x10000
   3   │ -DMBED_BOOT_STACK_SIZE=1024
   4   │ -DMBED_RAM_SIZE=0x40000
   5   │ -DMBED_RAM_START=0x20000000
   6   │ -DMBED_ROM_SIZE=0x100000
   7   │ -DMBED_ROM_START=0x0
   8   │ -DXIP_ENABLE=0
   9   │ -Wl,--gc-sections
  10   │ -Wl,--wrap,_calloc_r
  11   │ -Wl,--wrap,_free_r
  12   │ -Wl,--wrap,_malloc_r
  13   │ -Wl,--wrap,_memalign_r
  14   │ -Wl,--wrap,_realloc_r
  15   │ -Wl,--wrap,atexit
  16   │ -Wl,--wrap,exit
  17   │ -Wl,--wrap,main
  18   │ -Wl,-n
  19   │ -mcpu=cortex-m4
  20   │ -mfloat-abi=softfp
  21   │ -mfpu=fpv4-sp-d16
  22   │ -mthumb


And additionally from the cmdline of arduinon ide:

COPTS="-w -g3 -nostdlib -MMD -mcpu=cortex-m4 -mfloat-abi=softfp -mfpu=fpv4-sp-d16"


# Debug of the Blink application:


00018e74 <MemoryManagement_Handler>:
00018e7c <DebugMon_Handler>:
00018e82 <Default_Handler>:
00018e84 <NVIC_SetVector>:
00018e94 <NVIC_GetVector>:


00010000 00000100 T __Vectors

00010000 <__Vectors>:
   10000:       20040000        .word   0x20040000
   10004:       00018e39        .word   0x00018e39 Reset_Handler
   10008:       00018e71        .word   0x00018e71 NMI_Handler
   1000c:       000171ed        .word   0x000171ed
   10010:       00018e75        .word   0x00018e75 MemoryManagement_Handler
   10014:       000171f9        .word   0x000171f9
   10018:       000171ff        .word   0x000171ff
        ...
   1002c:       00012081        .word   0x00012081
   10030:       00018e7d        .word   0x00018e7d DebugMon_Handler
   10034:       00000000        .word   0x00000000
   10038:       0001211b        .word   0x0001211b
   1003c:       0001212b        .word   0x0001212b
   10040:       0001c691        .word   0x0001c691
   10044:       000144fd        .word   0x000144fd
   10048:       00018e83        .word   0x00018e83 NVIC_SetVector
   1004c:       00018e83        .word   0x00018e83
   10050:       00018e83        .word   0x00018e83
   10054:       00018e83        .word   0x00018e83
   10058:       00018e83        .word   0x00018e83
   1005c:       00018e83        .word   0x00018e83
   10060:       00018e83        .word   0x00018e83
   10064:       00018e83        .word   0x00018e83
   10068:       00018e83        .word   0x00018e83
   1006c:       00018e83        .word   0x00018e83
   10070:       00018e83        .word   0x00018e83
   10074:       0001c825        .word   0x0001c825
   10078:       00018e83        .word   0x00018e83
   1007c:       00014515        .word   0x00014515
   10080:       00018e83        .word   0x00018e83
   10084:       00018e83        .word   0x00018e83
   10088:       00018e83        .word   0x00018e83
   1008c:       00018e83        .word   0x00018e83
   10090:       00018e83        .word   0x00018e83
   10094:       00018e83        .word   0x00018e83
   10098:       00018e83        .word   0x00018e83
   1009c:       00018e83        .word   0x00018e83
   100a0:       00018e83        .word   0x00018e83
   100a4:       00018e83        .word   0x00018e83
   100a8:       00018e83        .word   0x00018e83
   100ac:       00018e83        .word   0x00018e83
   100b0:       00018e83        .word   0x00018e83
   100b4:       00018e83        .word   0x00018e83
        ...
   100c0:       00018e83        .word   0x00018e83
   100c4:       00018e83        .word   0x00018e83
   100c8:       00018e83        .word   0x00018e83
   100cc:       00018e83        .word   0x00018e83
   100d0:       00018e83        .word   0x00018e83
   100d4:       00018e83        .word   0x00018e83
   100d8:       00018e83        .word   0x00018e83
   100dc:       00018e83        .word   0x00018e83
   100e0:       00018e83        .word   0x00018e83
   100e4:       00018e83        .word   0x00018e83
   100e8:       00018e83        .word   0x00018e83
        ...
   100f4:       00018e83        .word   0x00018e83
   100f8:       00000000        .word   0x00000000
   100fc:       00018e83        .word   0x00018e83



00018e38 <Reset_Handler>:
   18e38:       4907            ldr     r1, [pc, #28]   ; (18e58 <Reset_Handler+0x20>)
   18e3a:       4a08            ldr     r2, [pc, #32]   ; (18e5c <Reset_Handler+0x24>)
   18e3c:       4b08            ldr     r3, [pc, #32]   ; (18e60 <Reset_Handler+0x28>)
   18e3e:       1a9b            subs    r3, r3, r2
   18e40:       dd03            ble.n   18e4a <Reset_Handler+0x12>
   18e42:       3b04            subs    r3, #4
   18e44:       58c8            ldr     r0, [r1, r3]
   18e46:       50d0            str     r0, [r2, r3]
   18e48:       dcfb            bgt.n   18e42 <Reset_Handler+0xa>
   18e4a:       4806            ldr     r0, [pc, #24]   ; (18e64 <Reset_Handler+0x2c>)
   18e4c:       4780            blx     r0
   18e4e:       4806            ldr     r0, [pc, #24]   ; (18e68 <Reset_Handler+0x30>)
   18e50:       4780            blx     r0
   18e52:       4806            ldr     r0, [pc, #24]   ; (18e6c <Reset_Handler+0x34>)
   18e54:       4700            bx      r0
   18e56:       0000            .short  0x0000
   18e58:       00023f40        .word   0x00023f40
   18e5c:       20000200        .word   0x20000200
   18e60:       20000fe8        .word   0x20000fe8
   18e64:       00018ec5        .word   0x00018ec5
   18e68:       0001967d        .word   0x0001967d
   18e6c:       00010141        .word   0x00010141

00018e70 <NMI_Handler>:
   18e70:       e7fe            b.n     18e70 <NMI_Handler>
   18e72:       e7fe            b.n     18e72 <NMI_Handler+0x2>

00018e74 <MemoryManagement_Handler>:
   18e74:       e7fe            b.n     18e74 <MemoryManagement_Handler>
   18e76:       e7fe            b.n     18e76 <MemoryManagement_Handler+0x2>
   18e78:       e7fe            b.n     18e78 <MemoryManagement_Handler+0x4>
   18e7a:       e7fe            b.n     18e7a <MemoryManagement_Handler+0x6>

00018e7c <DebugMon_Handler>:
   18e7c:       e7fe            b.n     18e7c <DebugMon_Handler>
   18e7e:       e7fe            b.n     18e7e <DebugMon_Handler+0x2>
   18e80:       e7fe            b.n     18e80 <DebugMon_Handler+0x4>

00018e82 <Default_Handler>:
   18e82:       e7fe            b.n     18e82 <Default_Handler>

00018e84 <NVIC_SetVector>:
   18e84:       4b02            ldr     r3, [pc, #8]    ; (18e90 <NVIC_SetVector+0xc>)
   18e86:       3010            adds    r0, #16
   18e88:       f843 1020       str.w   r1, [r3, r0, lsl #2]
   18e8c:       4770            bx      lr
   18e8e:       bf00            nop
   18e90:       20000000        .word   0x20000000

00018e94 <NVIC_GetVector>:
   18e94:       4b02            ldr     r3, [pc, #8]    ; (18ea0 <NVIC_GetVector+0xc>)
   18e96:       3010            adds    r0, #16
   18e98:       f853 0020       ldr.w   r0, [r3, r0, lsl #2]
   18e9c:       4770            bx      lr
   18e9e:       bf00            nop
   18ea0:       20000000        .word   0x20000000


00018ea4 <errata_103>:
   18ea4:       4b05            ldr     r3, [pc, #20]   ; (18ebc <errata_103+0x18>)
   18ea6:       681b            ldr     r3, [r3, #0]
   18ea8:       2b08            cmp     r3, #8
   18eaa:       bf01            itttt   eq
   18eac:       4b04            ldreq   r3, [pc, #16]   ; (18ec0 <errata_103+0x1c>)
   18eae:       6818            ldreq   r0, [r3, #0]
   18eb0:       fab0 f080       clzeq   r0, r0
   18eb4:       0940            lsreq   r0, r0, #5
   18eb6:       bf18            it      ne
   18eb8:       2000            movne   r0, #0
   18eba:       4770            bx      lr
   18ebc:       10000130        .word   0x10000130
   18ec0:       10000134        .word   0x10000134
