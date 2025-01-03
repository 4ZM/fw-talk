#![no_std]
#![no_main]

use panic_halt as _; // you can put a breakpoint on `rust_begin_unwind` to catch panics

use cortex_m::peripheral::syst::SystClkSource;
use cortex_m::peripheral::Peripherals;
use cortex_m_rt::{entry, exception};

static mut COUNTER: u32 = 0;

#[exception]
fn SysTick() {
    unsafe {
        if COUNTER > 0 {
            COUNTER -= 1;
        }
    }
}

fn delay(ms: u32) {
    unsafe {
        COUNTER = ms;
        while COUNTER > 0 {}
    }
}

#[entry]
fn main() -> ! {
    const MS_TICK: u32 = 0xfa00; // 64MHz x 1ms => 64000 (0xfa00) ticks

    let mut peripherals = Peripherals::take().unwrap();
    let syst = &mut peripherals.SYST;
    syst.set_clock_source(SystClkSource::Core);
    syst.set_reload(MS_TICK);  // Set the SysTick interrupt to trigger every 1ms
    syst.clear_current();
    syst.enable_interrupt();
    syst.enable_counter();

    const GPIO_P0_DIRSET: *mut u32 = 0x5000_0518 as *mut u32;
    const GPIO_P0_OUTSET: *mut u32 = 0x5000_0508 as *mut u32;
    const GPIO_P0_OUTCLR: *mut u32 = 0x5000_050c as *mut u32;
    const GPIO_PIN_LED_BUILTIN: u32 = 13;

    unsafe {
        core::ptr::write_volatile(GPIO_P0_DIRSET, 1 << GPIO_PIN_LED_BUILTIN);
    }

    loop {
        unsafe {
            core::ptr::write_volatile(GPIO_P0_OUTSET, 1 << GPIO_PIN_LED_BUILTIN);
            delay(1000);

            core::ptr::write_volatile(GPIO_P0_OUTCLR, 1 << GPIO_PIN_LED_BUILTIN);
            delay(1000);
        }
    }
}
