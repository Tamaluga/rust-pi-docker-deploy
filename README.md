# Automated Rust Deployment to Raspberry Pi with Docker

Example on how to deploy a Rust application to a Raspberry Pi by using Docker

## Setup Developer Host

1. Install Rust 
   Follow the instructions on the [Rust website](https://www.rust-lang.org/tools/install) to install Rust.

2. Install Cross 
   Install the `cross` tool for cross-compiling:  
   ```bash
   cargo install cross
   ```
3. Install the Cross Toolchain for Raspberry Pi 
   Add the target toolchain for the Raspberry Pi:  
   ```bash
   rustup target add arm-unknown-linux-gnueabihf
   ```
4. Install the Stable Toolchain for x86_64
   Add the stable toolchain for your development environment (x86_64):  
   ```bash
   rustup toolchain add stable-x86_64-unknown-linux-gnu --force-non-host
   ```

## Setup Github

1. Generate an SSH Key Pair 
   Create an SSH key pair with the following command: 
   ```bash
   ssh-keygen -t ed25519 -C "your_email@example.com"
   ```
2. Create GitHub Secrets 
   Add the following secrets in your GitHub repository (Settings > Secrets and variables > Actions > New repository secret): 
   - `DOCKER_USERNAME`: your docker hub username
   - `DOCKER_PASSWORD`: your docker hub password
   - `RASPI_IP`: ip-address of your raspberry pi
   - `RASPI_USER`: user name
   - `RASPI_PRIVATE_SSH_KEY`: The private ssh key

## Setup Raspberry Pi

The project is set up to work with ARM-based Raspberry Pi devices, including the Raspberry Pi Zero 2, Raspberry Pi 3, Raspberry Pi 4, and Raspberry Pi 400.

Install Docker  
Follow the [Docker installation guide for Debian-based systems](https://docs.docker.com/engine/install/debian/#install-using-the-repository) for 64-bit Raspberry Pi OS.

Manage Docker as a Non-Root User  
Follow the steps in the [Docker post-installation guide](https://docs.docker.com/engine/install/linux-postinstall/) to allow your user to run Docker without `sudo`.

## Build

### Cross compile on the dev host

To cross-compile your Rust application for the Raspberry Pi:

```bash
cross build --target=arm-unknown-linux-gnueabihf
scp target/arm-unknown-linux-gnueabihf/debug/rust-pi-docker-deploy RASPI_USER@RASPI_IP:~
```

### Build the docker container on the dev host

#### Targeting the Raspi

Build, tag and push the Docker Image on the dev host: 
```bash
docker build --platform linux/arm64 -t rust-pi-docker-deploy .
docker tag rust-pi-docker-deploy DOCKER_USER/rust-pi-docker-deploy:test
docker push DOCKER_USER/rust-pi-docker-deploy:test
```

Run the Docker Container on the Raspberry Pi:
```bash
docker run --rm DOCKER_USER/rust-pi-docker-deploy:test
```

#### Targeting the dev host

Build and run the Docker Image on the dev host: 
```bash
docker build --platform linux/amd64 -t rust-pi-docker-deploy .
docker run --rm rust-pi-docker-deploy
```