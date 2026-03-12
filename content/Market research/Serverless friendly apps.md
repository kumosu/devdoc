This report was produced by Claude AI.
# Self-Hosted App Landscape for KUMO.SU

Research on apps suitable for a private cloud (BYOC), evaluated for compute efficiency.
Key criteria: language, storage/queue dependencies, idle resource usage.

---

## Messaging — Matrix

| App | Lang | Storage | Queue | Notes |
|-----|------|---------|-------|-------|
| **Conduit** | Rust | Embedded RocksDB/sled | none | Monolithic, no external deps, ~500MB RAM |
| **conduwuit** | Rust | Embedded RocksDB | none | Active fork of Conduit, more maintained, same profile |
| **Dendrite** | Go | PostgreSQL (required) | none | Designed for small servers, SQLite dev-only |
| **Synapse** | Python | PostgreSQL | Redis | Reference impl, heavy — skip for personal use |

**Verdict:** Conduit/conduwuit is ideal — single binary, no external DB, Rust efficiency. Dendrite viable if PostgreSQL is a shared PCI resource. Synapse is a non-starter for single-user.

---

## Personal Storage — Photos

| App | Lang | Storage | Queue | Notes |
|-----|------|---------|-------|-------|
| **Immich** | TypeScript (server) + Python (ML) | PostgreSQL, S3-compatible | Redis | Heavy: 2 services, ML model for face/object detection |
| **PhotoPrism** | Go | SQLite or MariaDB, local/S3 | none | Lighter, Go binary, but needs good DB for large libraries |

**Verdict:** Immich is feature-rich (mobile apps, face recognition) but heavy — PostgreSQL + Redis + Python ML service. PhotoPrism with SQLite is lighter. Neither is WASM-portable (ffmpeg/native ML dependency). Both require significant storage I/O for thumbnailing.

---

## Git Server

| App | Lang | Storage | Queue | Notes |
|-----|------|---------|-------|-------|
| **Forgejo** | Go | SQLite (default), PostgreSQL/MySQL | none | Community fork of Gitea, 1GB RAM sufficient, single binary |
| **Gitea** | Go | SQLite (default), PostgreSQL/MySQL | none | Same profile, more corporate-driven |
| **GitLab** | Ruby | PostgreSQL, Redis, Sidekiq | Redis+Sidekiq | Very heavy — skip |

**Verdict:** Forgejo is a near-perfect KUMO.SU app — Go binary, SQLite default, runs on Raspberry Pi. PRs, CI/CD, issue tracking included.

---

## Social Networks — Federated (Twitter alternatives)

| App | Lang | Storage | Queue | Notes |
|-----|------|---------|-------|-------|
| **microblog.pub** | Python | SQLite | none | Single-user only, ActivityPub, minimal |
| **Akkoma** | Elixir | PostgreSQL | none (built-in) | Fork of Pleroma, efficient concurrency, no Redis |
| **Pleroma** | Elixir | PostgreSQL | none (built-in) | Similar to Akkoma, slightly less maintained |
| **Mastodon** | Ruby | PostgreSQL + Redis | Sidekiq (Redis) | Heavy: 3 processes, memory-hungry Ruby runtime |
| **Misskey/Firefish** | TypeScript | PostgreSQL | Redis | Feature-rich but heavier than Pleroma/Akkoma |

**Verdict:**
- Single-user (Tier I): **microblog.pub** — Python + SQLite, minimal footprint.
- Small community (Tier II): **Akkoma** — Elixir is surprisingly efficient, no Redis needed, PostgreSQL only. Mastodon is a poor fit (Sidekiq + Redis + Ruby memory leaks documented).

---

## Social Networks — Instagram Alternative

| App | Lang | Storage | Queue | Notes |
|-----|------|---------|-------|-------|
| **Pixelfed** | PHP/Laravel | PostgreSQL or MySQL | Redis | ActivityPub federated, mobile apps launched Jan 2025 |

**Verdict:** PHP + Redis + PostgreSQL is not lightweight, but it's the only mature option. Mobile apps now exist. Federated via ActivityPub.

---

## Video Hosting — YouTube Alternative

| App | Lang | Storage | Queue | Notes |
|-----|------|---------|-------|-------|
| **PeerTube** | TypeScript/Node.js | PostgreSQL | Redis | P2P WebRTC video distribution, ffmpeg transcoding, ActivityPub federated |

**Verdict:** Requires PostgreSQL + Redis + ffmpeg. Video transcoding is inherently compute-heavy. P2P via WebRTC reduces server bandwidth by offloading delivery to viewers. S3-compatible storage recommended for video files. No lightweight alternative exists.

---

## Music Streaming

| App           | Lang          | Storage    | Queue | Notes                                                          |
| ------------- | ------------- | ---------- | ----- | -------------------------------------------------------------- |
| **Navidrome** | Go            | SQLite     | none  | Single binary, ~50MB RAM, ffmpeg for transcoding, Subsonic API |
| **Funkwhale** | Python/Django | PostgreSQL | Redis | ActivityPub-federated music sharing, heavier but social        |

**Verdict:** Navidrome is a perfect KUMO.SU app — Go binary + SQLite + optional ffmpeg. ~50MB idle RAM. Funkwhale interesting for the social/federation angle (ActivityPub for music libraries) but much heavier stack.

---

## Password Manager

| App | Lang | Storage | Queue | Notes |
|-----|------|---------|-------|-------|
| **Vaultwarden** | Rust | SQLite (default), PostgreSQL, MySQL | none | Unofficial Bitwarden-compatible server, extremely lightweight |

**Verdict:** Rust + SQLite — the ideal KUMO.SU app archetype. Idles at near-zero resources. Already planned.

---

## AI — Orchestration & Model Hosting

| App | Lang | Storage | Queue | Notes |
|-----|------|---------|-------|-------|
| **Ollama** | Go | Local GGUF model files | none | Runs LLMs locally (CPU/GPU), OpenAI-compatible API |
| **LocalAI** | Go | Local model files | none | Drop-in OpenAI API replacement, supports text/image/audio/embeddings |
| **Open WebUI** | Python + SvelteKit | SQLite or PostgreSQL | none (Redis optional) | Chat UI for Ollama/OpenAI backends, RAG, 9 vector DB options |
| **n8n** | TypeScript/Node.js | SQLite or PostgreSQL | none | Workflow automation / AI agent orchestration |

**Verdict:**
- **Ollama** is the core runtime — Go binary, talks to GPU/CPU. Model files are large (4–70GB) but that's storage, not idle compute.
- **Open WebUI** in SQLite mode is lightweight at idle.
- Real constraint: **GPU access** — Ollama needs GPU passthrough or runs slowly on CPU. This maps to the "hardware resources" note in the spec.
- Open WebUI can proxy to Anthropic/OpenAI APIs as a fallback when no local GPU is available.

---

## Bonus Categories

### Bookmarks & Read-Later

| App | Lang | Storage | Notes |
|-----|------|---------|-------|
| **Linkding** | Python/Django | SQLite | Minimal, fast, Docker-friendly |
| **Karakeep** (ex-Hoarder) | TypeScript/Next.js | SQLite or PostgreSQL | AI auto-tagging, archives links/notes/images |
| **Wallabag** | PHP | SQLite or MySQL | Read-later + e-reader send |

### RSS / Feed Aggregation

| App          | Lang | Storage    | Notes                              |
| ------------ | ---- | ---------- | ---------------------------------- |
| **Miniflux** | Go   | PostgreSQL | Minimal, fast, API-first           |
| **Fusion**   | Go   | SQLite     | ~80MB RAM, includes bookmarks, PWA |

**Strategic note:** RSS is the original open social graph. A personal aggregator could be the backbone for the "social discovery" use case (RSS/ActivityPub/ATProto aggregation) mentioned in the spec.

### E-Reader Sync

| App | Lang | Storage | Notes |
|-----|------|---------|-------|
| **Kavita** | C#/.NET | SQLite | Manga/comics/books server, lightweight |
| **Calibre-Web** | Python | SQLite | Web UI for Calibre library, KOReader sync support |

### VPN / Network Mesh

| App | Lang | Storage | Notes |
|-----|------|---------|-------|
| **Headscale** | Go | SQLite or PostgreSQL | Self-hosted Tailscale control plane |

**Strategic note for KUMO.SU:** If each PCI runs Headscale or connects to a shared instance, servlet-to-servlet communication across user instances becomes trivially secure without public exposure. Relevant for the "Servlet -> Servlet" communication type in the spec.

### Home Automation

| App | Lang | Storage | Notes |
|-----|------|---------|-------|
| **Home Assistant** | Python | SQLite | 1000+ integrations, large ecosystem |

Probably too hardware-coupled for KUMO.SU (needs local network access to devices), but worth knowing as a use-case driver.

### Team Communication (Slack alternative)

| App | Lang | Storage | Notes |
|-----|------|---------|-------|
| **Mattermost** | Go + React | PostgreSQL | Self-hosted Slack, solid free tier |
| **Rocket.Chat** | TypeScript | MongoDB | More features, heavier |

---

## Compute Efficiency Summary

**Best fit for KUMO.SU** (single binary, SQLite, low idle RAM):

| Tier | App | Stack | Idle RAM |
|------|-----|-------|----------|
| Best | Vaultwarden | Rust + SQLite | ~10MB |
| Best | Navidrome | Go + SQLite | ~50MB |
| Best | Conduit/conduwuit | Rust + embedded DB | ~500MB |
| Best | Forgejo | Go + SQLite | ~100MB |
| Best | microblog.pub | Python + SQLite | ~100MB |
| Good | Akkoma | Elixir + PostgreSQL | ~300MB |
| Good | Open WebUI | Python + SQLite | ~200MB |
| Good | PhotoPrism | Go + SQLite/MariaDB | ~300MB |
| Heavy | Pixelfed | PHP + PostgreSQL + Redis | ~500MB+ |
| Heavy | Immich | Node.js + Python + PostgreSQL + Redis | ~1GB+ |
| Heavy | PeerTube | Node.js + PostgreSQL + Redis | ~600MB+ |
| Heavy | Mastodon | Ruby + PostgreSQL + Redis + Sidekiq | ~1.5GB+ |

**Key pattern:** Go/Rust + SQLite = ideal KUMO.SU servlet archetype. Elixir (Akkoma) is an interesting outlier — efficient concurrency with no Redis despite being social/federated. The Redis + PostgreSQL + queue stack (Mastodon, PeerTube, Pixelfed) is the hardest to run efficiently at low utilization.

---

## Sources

- [Dendrite - matrix-org/dendrite](https://github.com/matrix-org/dendrite)
- [Matrix.org Servers Ecosystem](https://matrix.org/ecosystem/servers/)
- [Immich Comparison](https://docs.immich.app/overview/comparison/)
- [Navidrome - navidrome/navidrome](https://github.com/navidrome/navidrome)
- [Self-Hosted Git Platforms: GitLab vs Gitea vs Forgejo 2026](https://dasroot.net/posts/2026/01/self-hosted-git-platforms-gitlab-gitea-forgejo-2026/)
- [The architecture of Mastodon](https://softwaremill.com/the-architecture-of-mastodon/)
- [PeerTube Architecture](https://docs.joinpeertube.org/contribute/architecture)
- [Vaultwarden - dani-garcia/vaultwarden](https://github.com/dani-garcia/vaultwarden)
- [microblog.pub docs](https://docs.microblog.pub/)
- [Local LLM Hosting Complete Guide](https://medium.com/@rosgluk/local-llm-hosting-complete-2025-guide-ollama-vllm-localai-jan-lm-studio-more-f98136ce7e4a)
- [Karakeep (formerly Hoarder)](https://github.com/karakeep-app/karakeep)
- [Miniflux - lightweight self-hosted RSS](https://funkypenguin.co.nz/blog/miniflux-lightweight-self-hosted-rss-reader/)
- [Fusion RSS reader](https://github.com/0x2E/fusion)
- [Pixelfed launches mobile apps](https://techcrunch.com/2025/01/14/decentralized-instagram-alternative-pixelfed-launches-mobile-apps/)
- [Comparing Fediverse software efficiency](https://stefanlaser.net/2023/12/18/comparing-fediverse-software.html)
- [Self-Hosted AI Battle: Ollama vs LocalAI](https://dev.to/arkhan/self-hosted-ai-battle-ollama-vs-localai-for-developers-2025-edition-b82)
