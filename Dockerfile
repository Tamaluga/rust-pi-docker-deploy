# Build stage
FROM messense/rust-musl-cross:x86_64-musl AS builder
# Set the working directory
WORKDIR /raspi-deploy-example
# Copy the entire project
COPY . .
# Build the application
RUN cargo build --release

# Run stage
FROM debian:bookworm-slim
# Copy the compiled binary from the builder stage
COPY --from=builder /raspi-deploy-example/target/release/raspi-deploy-example /raspi-deploy-example
# Set the command to run the application
CMD ["/raspi-deploy-example"]