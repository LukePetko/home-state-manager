# Build stage
FROM elixir:1.19-alpine AS builder

# Install build dependencies
RUN apk add --no-cache build-base git

# Set working directory
WORKDIR /app

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Set build environment
ENV MIX_ENV=prod

# Copy mix files
COPY mix.exs mix.lock ./

# Install dependencies
RUN mix deps.get --only prod && \
    mix deps.compile

# Copy application code
COPY config ./config
COPY lib ./lib
COPY priv ./priv

# Compile application
RUN mix compile

# Runtime stage
FROM elixir:1.19-alpine AS runtime

# Install runtime dependencies
RUN apk add --no-cache openssl ncurses-libs libstdc++

# Set working directory
WORKDIR /app

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Set runtime environment
ENV MIX_ENV=prod

# Copy compiled application from builder
COPY --from=builder /app/_build /app/_build
COPY --from=builder /app/deps /app/deps
COPY --from=builder /app/config /app/config
COPY --from=builder /app/lib /app/lib
COPY --from=builder /app/priv /app/priv
COPY --from=builder /app/mix.exs /app/mix.lock ./

# Expose port (adjust if needed)
EXPOSE 4000

# Set default command
CMD ["mix", "run", "--no-halt"]
