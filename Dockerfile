# Build stage
FROM messense/rust-musl-cross:aarch64-musl AS builder
# Set the working directory
WORKDIR /raspi-deploy-example
# Copy the entire project
COPY . .
# Build the application
RUN cargo build --release --target=aarch64-unknown-linux-musl

# Run stage
FROM scratch
# Copy the compiled binary from the builder stage
COPY --from=builder /raspi-deploy-example/target/aarch64-unknown-linux-musl/release/raspi-deploy-example /raspi-deploy-example
# Set the command to run the application
CMD ["/raspi-deploy-example"]