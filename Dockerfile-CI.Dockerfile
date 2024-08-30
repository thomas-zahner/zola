FROM alpine AS builder
WORKDIR /app

RUN apk add jq wget && \
  case $(uname -m) in \
    "x86_64") \
      wget -q -O - "$(wget -q -O- https://api.github.com/repos/getzola/zola/releases/latest \
      | jq -r '.assets[].browser_download_url' \
      | grep x86_64-unknown-linux-gnu)" | tar -xz zola \
    ;; \
    "aarch64") \
      echo "TODO" && exit 1 \
    ;; \
  esac && \
  chmod +x zola

FROM gcr.io/distroless/cc-debian12
COPY --from=builder /app/zola /bin/zola
ENTRYPOINT [ "/bin/zola" ]
