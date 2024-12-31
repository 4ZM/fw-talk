typedef unsigned int *isr_vector;

extern unsigned int _data_start_flash, _data_start, _data_end;
extern unsigned int _bss_start, _bss_end;
extern unsigned int _stack_top;

void Reset_Handler(void);
void NMI_Handler(void) __attribute__((alias("Default_Handler")));
void HardFault_Handler(void) __attribute__((alias("Default_Handler")));
void MemManage_Handler(void) __attribute__((alias("Default_Handler")));
void BusFault_Handler(void) __attribute__((alias("Default_Handler")));
void UsageFault_Handler(void) __attribute__((alias("Default_Handler")));
void SVC_Handler(void) __attribute__((alias("Default_Handler")));
void DebugMon_Handler(void) __attribute__((alias("Default_Handler")));
void PendSV_Handler(void) __attribute__((alias("Default_Handler")));
void SysTick_Handler(void) __attribute__((alias("Default_Handler")));

void Default_Handler(void) {
  for (;;) {
  }
}

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

int main(void);

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

int main(void) {
  unsigned int gpio_p0 = 0x50000000;
  unsigned int gpio_outset = 0x508;
  unsigned int gpio_dirset = 0x518;

  unsigned int led_builtin = 13; // P0.13 LED_BUILTIN (yellow)

  *((unsigned int *)(gpio_p0 + gpio_dirset)) = 1 << led_builtin;
  *((unsigned int *)(gpio_p0 + gpio_outset)) = 1 << led_builtin;
  for (;;) {
  }
}
