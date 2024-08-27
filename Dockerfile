FROM rust:slim-bookworm AS builder

WORKDIR /app
COPY . .

RUN cargo build --release

FROM gcr.io/distroless/cc-debian12
COPY --from=builder /app/target/release/zola /bin/zola
ENTRYPOINT [ "/bin/zola" ]
