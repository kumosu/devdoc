This docs was produced by Claude AI
# Dendrite Matrix Homeserver

[Dendrite](https://github.com/matrix-org/dendrite) is a second-generation Matrix homeserver written in Go, designed to be lightweight and efficient.

---

## Dependencies

| Dependency | Details |
|---|---|
| **Go** | 1.21+ (for building from source) |
| **PostgreSQL** | 12+ recommended (SQLite supported but not for production/federation) |
| **NATS Server** | Built-in — no separate install needed |
| **Reverse Proxy** | nginx, Caddy, or HAProxy (required for TLS/federation) |
| **TLS Certificate** | Valid public cert required for federation (Let's Encrypt works) |

---

## Docker Setup

### 1. Directory & Key Generation

```bash
mkdir -p /etc/dendrite

# Generate server keys and TLS certs
docker run --rm --entrypoint="" \
  -v /etc/dendrite:/etc/dendrite \
  matrixdotorg/dendrite-monolith:latest \
  /usr/bin/generate-keys \
  -private-key /etc/dendrite/matrix_key.pem \
  -tls-cert /etc/dendrite/server.crt \
  -tls-key /etc/dendrite/server.key
```

### 2. Generate `dendrite.yaml`

```bash
docker run --rm --entrypoint="" \
  -v /etc/dendrite:/etc/dendrite \
  matrixdotorg/dendrite-monolith:latest \
  /usr/bin/generate-config \
  -server your.domain.com \
  -db postgresql://dendrite:password@postgres/dendrite \
  > /etc/dendrite/dendrite.yaml
```

### 3. `docker-compose.yml`

```yaml
version: "3.8"
services:
  dendrite:
    image: matrixdotorg/dendrite-monolith:latest
    ports:
      - "8008:8008"
      - "8448:8448"
    volumes:
      - ./config:/etc/dendrite
      - dendrite_media:/var/dendrite/media
      - dendrite_jetstream:/var/dendrite/jetstream
      - dendrite_search_index:/var/dendrite/searchindex
    depends_on:
      - postgres
    restart: unless-stopped

  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_PASSWORD: yourpassword
      POSTGRES_USER: dendrite
      POSTGRES_DATABASE: dendrite
    volumes:
      - dendrite_postgres:/var/lib/postgresql/data
    restart: unless-stopped

volumes:
  dendrite_media:
  dendrite_jetstream:
  dendrite_postgres:
  dendrite_search_index:
```

---

## Reverse Proxy

### Caddy (recommended — automatic TLS)

```caddyfile
your.domain.com {
    reverse_proxy /_matrix/* localhost:8008
    reverse_proxy /_synapse/* localhost:8008
}
```

### nginx

Proxy all `/_matrix` paths to port `8008`, listening on ports `443` and `8448` with TLS.

---

## Key Notes

- **Port 8008** — client API (HTTP, behind reverse proxy)
- **Port 8448** — federation API (Matrix server-to-server)
- SQLite is fine for testing only; PostgreSQL is required for federation/production
- The `matrix_key.pem` file is the server's permanent identity — back it up
- `dendrite.yaml` and `matrix_key.pem` must be present in the mounted config volume before starting

---

## Sources

- [Installing Dendrite using Docker Compose](https://matrix-org.github.io/dendrite/installation/docker/install)
- [dendrite/build/docker/docker-compose.yml](https://github.com/matrix-org/dendrite/blob/main/build/docker/docker-compose.yml)
- [dendrite/build/docker/README.md](https://github.com/matrix-org/dendrite/blob/main/build/docker/README.md)
- [matrixdotorg/dendrite-monolith Docker Image](https://hub.docker.com/r/matrixdotorg/dendrite-monolith)
- [Planning your installation | Dendrite](https://matrix-org.github.io/dendrite/installation/planning)
- [Caddy as a reverse proxy to Dendrite](https://xiu.io/posts/14-caddy-reverse-proxy-dendrite/)
- [Setting up the domain | Dendrite](https://matrix-org.github.io/dendrite/installation/domainname)
