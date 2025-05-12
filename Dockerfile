# ARGUMENTS --------------------------------------------------------------------
ARG BUILD=debug
# Base image to run the validation script
FROM alpine AS validator
ARG BUILD
# Validate arguments
RUN if [ "$BUILD" != "release" ] && [ "$BUILD" != "debug" ]; then \
      echo "Error: BUILD must be either 'release' or 'debug'." >&2; \
      exit 1; \
    fi

# BUILD STAGE ------------------------------------------------------------------
FROM messense/rust-musl-cross:aarch64-musl AS builder
ARG BUILD
# Set the working directory
WORKDIR /app
# Copy the entire project
COPY . .
# Build the application
RUN cargo build $( [ "$BUILD" = "release" ] && echo --release ) \
    --target=aarch64-unknown-linux-musl

# RUN STAGE ---------------------------------------------------------------------
FROM scratch
ARG BUILD
# Copy the compiled binary from the builder stage
COPY --from=builder /app/target/aarch64-unknown-linux-musl/$BUILD/rust-pi-docker-deploy /rust-pi-docker-deploy
# Set the command to run the application
CMD ["/rust-pi-docker-deploy"]
