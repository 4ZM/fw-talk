/* https://blog.thea.codes/the-most-thoroughly-commented-linker-script/ */

ENTRY(Reset_Handler)

MEMORY {
  FLASH (rx)  : ORIGIN = 0x00000000, LENGTH = 64K
  RAM   (rwx) : ORIGIN = 0x20000000, LENGTH = 256K
}

SECTIONS {

  .vectors (READONLY) : { /* warning: build/blink.elf has a LOAD segment with RWX permissions - .text automtically READONLY */
    KEEP(*(.vectors))  /* KEEP() prevent optimizing away */
  } > FLASH

  .text : ALIGN(4){
    *(.text)
    *(.text.*)
    *(.rodata*)
  } > FLASH

  .data : {
    _data_start_flash = LOADADDR(.data);
    _data_start = .;
    *(.data)
    *(.data.*)
    /* *(.ramfunc*) adding __attribute__((section(".ramfunc"))) to function to store them in RAM */
    _data_end = .;
  } > RAM AT> FLASH

  .bss : ALIGN(4) /* (NOLOAD) is default */ {
    _bss_start = .;
    *(.bss)    /* Both prevent .bssfoo from matching */
    *(.bss.*)
    /* *(COMMON) Not needed: -fno-common default */
    _bss_end = .;
  } > RAM

.stack (NOLOAD) : ALIGN(8) {
    . = ALIGN(8);
    _stack_bottom = .;
    . += 0x400;
    _stack_top = .;
  } > RAM
}
