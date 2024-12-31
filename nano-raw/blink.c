typedef unsigned int *isr_vector;

extern unsigned int _data_start_flash, _data_start, _data_end;
extern unsigned int _bss_start, _bss_end;
extern unsigned int _stack_top;

int main(void);

void Reset_Handler(void);
void NMI_Handler(void) __attribute__((alias("Default_Handler")));
void HardFault_Handler(void) __attribute__((alias("Default_Handler")));
void MemManage_Handler(void) __attribute__((alias("Default_Handler")));
void BusFault_Handler(void) __attribute__((alias("Default_Handler")));
void UsageFault_Handler(void) __attribute__((alias("Default_Handler")));
void SVC_Handler(void) __attribute__((alias("Default_Handler")));
void DebugMon_Handler(void) __attribute__((alias("Default_Handler")));
void PendSV_Handler(void) __attribute__((alias("Default_Handler")));
void SysTick_Handler(void);

__attribute__((section(".vectors"))) isr_vector isr_vectors[] = {
    &_stack_top,
    (isr_vector)Reset_Handler,
    (isr_vector)NMI_Handler,
    (isr_vector)HardFault_Handler,
    (isr_vector)MemManage_Handler,
    (isr_vector)BusFault_Handler,
    (isr_vector)UsageFault_Handler,
    0,
    0,
    0,
    0, // Reserved
    (isr_vector)SVC_Handler,
    (isr_vector)DebugMon_Handler,
    0, // Reserved
    (isr_vector)PendSV_Handler,
    (isr_vector)SysTick_Handler};

void Reset_Handler(void) {

  // Copy data section from Flash to RAM
  unsigned int *src = &_data_start_flash;
  unsigned int *dest = &_data_start;
  while (dest < &_data_end) {
    *dest++ = *src++;
  }

  // Zero initialize the BSS section
  dest = &_bss_start;
  while (dest < &_bss_end) {
    *dest++ = 0;
  }

  main();

  for (;;) {
  }
}

volatile unsigned int counter = 0;

void SysTick_Handler(void) {
  if (counter)
    --counter;
}

void Default_Handler(void) {
  for (;;) {
  }
}

int main(void) {

  const unsigned int MS_TICK = 0xfa00; // 64MHz x 1ms => 64000 (0xfa00) ticks

  // Arm Cortex-M4 Technical Reference
  //   4.1 System control registers
  const unsigned int STCSR = 0xE000E010; // Control and Status Register
  const unsigned int STRVR = 0xE000E014; // Reload Value Register
  const unsigned int STCVR = 0xE000E018; // Current Value Register

  // Arm7-M Architecture Reference Manual (B3.3.1 SysTick operation)
  *((unsigned int *)STRVR) = MS_TICK - 1;
  *((unsigned int *)STCVR) = 0;

  // Arm7-M Architecture Reference Manual
  //   B3.3.3 SysTick Control and Status Register, SYST_CSR
  unsigned int CLKSOURCE_BIT = 1 << 2; // 1 => SysTick uses the processor clock
  unsigned int TICKINT_BIT = 1 << 1;   // 1 => SysTick exception to pending on 0
  unsigned int ENABLE_BIT = 1 << 0;    // 1 => Counter is operating.
  *((unsigned int *)STCSR) = CLKSOURCE_BIT | TICKINT_BIT | ENABLE_BIT;

  // IO
  unsigned int gpio_p0 = 0x50000000;
  unsigned int gpio_outset = 0x508;
  unsigned int gpio_outclr = 0x50C;
  unsigned int gpio_dirset = 0x518;

  unsigned int led_builtin = 13; // P0.13 LED_BUILTIN (yellow)

  *((unsigned int *)(gpio_p0 + gpio_dirset)) = 1 << led_builtin;

  for (;;) {
    *((unsigned int *)(gpio_p0 + gpio_outset)) = 1 << led_builtin;

    counter = 1000;
    while (counter) {
    }

    *((unsigned int *)(gpio_p0 + gpio_outclr)) = 1 << led_builtin;

    counter = 1000;
    while (counter) {
    }
  }
}
