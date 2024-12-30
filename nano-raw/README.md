# nRF52840 Product Specification v1.11

4.2 Memory: The nRF52840 contains 1024 kB of flash memory and 256 kB of RAM

4.2.3 Memory Map ?
  SRAM 0x20000000-0x40000000 (Data RAM)
  Code 0x00800000-0x10000000 (Code RAM)
  Code 0x00000000-0x00800000 (Flas)

4.2.4 Instantiation
0  0x50000000 P0 General purpose input and output, port 0
0  0x50000300 P1 General purpose input and output, port 1
6  0x40006000 GPIOTE GPIO tasks and events
8  0x40008000 TIMER0 Timer 0
9  0x40009000 TIMER1 Timer 1
10 0x4000A000 TIMER2 Timer 2
26 0x4001A000 TIMER3 Timer 3
27 0x4001B000 TIMER4 Timer 4

6.9 GPIO — General purpose input/output

6.9.2.2 OUTSET (+ 0x508)

Write: a '1' sets the pin high; a '0' has no effect

Address offset:

Bits [31..0]

Pin 06
Pin 13
Pin 16
Pin 24

6.9.2.3 OUTCLR (+ 0x50C)
6.9.2.4 IN (+ 0x510)  Read GPIO port
6.9.2.6 DIRSET (+ 0x518)
Write: a '1' sets pin to output; a '0' has no effect

6.9.2.7 DIRCLR (+ 0x51C)
Write: a '1' sets pin to input; a '0' has no effect

6.9.2.23 PIN_CNF[13]
Address offset: 0x734
Configuration of GPIO pins


# arduino docs

4 Connector Pinouts

P0.13 LED_BUILTIN (yellow)

RGB Led
P0.24 (R)
P0.16 (G)
P0.06 (B)



# Arm® Cortex®-M4 Processor Technical Reference Manual

3.4 Processor memory model

Peripheral 0.5GB 0x40000000 - 0x60000000
SRAM 0.5GB 0x20000000 - 0x40000000
Code 0.5GB 0x00000000 - 0x20000000
