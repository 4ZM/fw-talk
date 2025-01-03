Project created with

$ cargo install cargo-binutils
$ rustup component add llvm-tools
$ cargo install cargo-generate
$ rustup target add thumbv7m-none-eabi
$ cargo generate --git https://github.com/rust-embedded/cortex-m-quickstart


Run in gdb:
$ gdb-multiarch -x openocd.gdb target/thumbv7m-none-eabi/debug/nano-rust

or just "cargo run"

Use probe-rs to flash (https://probe.rs/docs/tools/cargo-flash/):
$ cargo flash --release --chip nRF52840_xxAA
