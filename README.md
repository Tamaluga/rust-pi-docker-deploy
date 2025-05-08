# raspi-deploy-example

Example on how to deploy a Rust application to a Raspberry Pi by using Docker

## Setup Developer Host

- Install Rust: https://www.rust-lang.org/tools/install
- Install Cross: cargo install cross
- Install cross toolchain for raspi: rustup target add arm-unknown-linux-gnueabihf
rustup toolchain add stable-x86_64-unknown-linux-gnu --force-non-host

## Setup Raspberry Pi

install Docker
32-bit: https://docs.docker.com/engine/install/raspberry-pi-os/#install-using-the-repository
64-bit: https://docs.docker.com/engine/install/debian/#install-using-the-repository
Manage docker as a non-root user
https://docs.docker.com/engine/install/linux-postinstall/

## Build

cross build --release --target=arm-unknown-linux-gnueabihf



## Docker
docker build --platform linux/arm/v7 -t raspi-deploy-example .
docker tag raspi-deploy-example tamaluga/raspi-deploy-example:test
docker push tamaluga/raspi-deploy-example:test