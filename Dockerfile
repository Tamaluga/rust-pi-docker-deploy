# Build stage
FROM messense/rust-musl-cross:aarch64-musl AS builder
# Set the working directory
WORKDIR /rust-pi-docker-deploy
# Copy the entire project
COPY . .
# Build the application
RUN cargo build --release --target=aarch64-unknown-linux-musl

# Run stage
FROM scratch
# Copy the compiled binary from the builder stage
COPY --from=builder /rust-pi-docker-deploy/target/aarch64-unknown-linux-musl/release/rust-pi-docker-deploy /rust-pi-docker-deploy
# Set the command to run the application
CMD ["/rust-pi-docker-deploy"]