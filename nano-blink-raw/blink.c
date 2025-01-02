typedef unsigned int uint;

extern uint _data_start_flash, _data_start, _data_end;
extern uint _bss_start, _bss_end;
extern uint _stack_top;

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

__attribute__((section(".vectors")))
uint *isr_vectors[] = {&_stack_top,
                       (uint *)Reset_Handler,
                       (uint *)NMI_Handler,
                       (uint *)HardFault_Handler,
                       (uint *)MemManage_Handler,
                       (uint *)BusFault_Handler,
                       (uint *)UsageFault_Handler,
                       0,
                       0,
                       0,
                       0, // Reserved
                       (uint *)SVC_Handler,
                       (uint *)DebugMon_Handler,
                       0, // Reserved
                       (uint *)PendSV_Handler,
                       (uint *)SysTick_Handler};

void Reset_Handler(void) {

  // Copy data section from Flash to RAM
  uint *src = &_data_start_flash;
  uint *dest = &_data_start;
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

volatile uint counter = 0;

void SysTick_Handler(void) {
  if (counter)
    --counter;
}

void Default_Handler(void) {
  for (;;) {
  }
}

const uint MS_TICK = 0xfa00; // 64MHz x 1ms => 64000 (0xfa00) ticks

// Arm Cortex-M4 Technical Reference
//   4.1 System control registers
const uint STCSR = 0xE000E010; // Control and Status Register
const uint STRVR = 0xE000E014; // Reload Value Register
const uint STCVR = 0xE000E018; // Current Value Register

// IO
// nRF52840 Product Specification v1.11
//   6.9.2 Registers

const uint GPIO_P0 = 0x50000000;
const uint GPIO_OUTSET = 0x508;
const uint GPIO_OUTCLR = 0x50C;
const uint GPIO_DIRSET = 0x518;
const uint GPIO_DIRCLR = 0x50C;
const uint GPIO_PIN_LED_BUILTIN = 13; // P0.13 GPIO_PIN_LED_BUILTIN (yellow)

void set_pin(uint pin, uint value) {
  if (value)
    *((uint *)(GPIO_P0 + GPIO_OUTSET)) = 1 << GPIO_PIN_LED_BUILTIN;
  else
    *((uint *)(GPIO_P0 + GPIO_OUTCLR)) = 1 << GPIO_PIN_LED_BUILTIN;
}

void delay_ms(uint ms) {
  counter = 1000;
  while (counter) {
  }
}

void setup() {
  // Arm7-M Architecture Reference Manual (B3.3.1 SysTick operation)
  *((uint *)STRVR) = MS_TICK - 1;
  *((uint *)STCVR) = 0;

  // Arm7-M Architecture Reference Manual
  //   B3.3.3 SysTick Control and Status Register, SYST_CSR
  uint CLKSOURCE_BIT = 1 << 2; // 1 => SysTick uses the processor clock
  uint TICKINT_BIT = 1 << 1;   // 1 => SysTick exception to pending on 0
  uint ENABLE_BIT = 1 << 0;    // 1 => Counter is operating.
  *((uint *)STCSR) = CLKSOURCE_BIT | TICKINT_BIT | ENABLE_BIT;

  // Configure LED IO pin as output
  *((uint *)(GPIO_P0 + GPIO_DIRSET)) = 1 << GPIO_PIN_LED_BUILTIN;
}

void loop() {
  set_pin(GPIO_PIN_LED_BUILTIN, 1);
  delay_ms(1000);

  set_pin(GPIO_PIN_LED_BUILTIN, 0);
  delay_ms(1000);
}

int main(void) {

  setup();

  for (;;) {
    loop();
  }
}
