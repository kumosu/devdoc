# ── dev stage ────────────────────────────────────────────────────────────────
FROM node:22-slim AS dev

RUN apt-get update && apt-get install -y --no-install-recommends git ca-certificates && rm -rf /var/lib/apt/lists/*

# Clone Quartz 4 (pinned to stable v4 branch)
RUN git clone --depth 1 --branch v4 https://github.com/jackyzha0/quartz.git /quartz

WORKDIR /quartz
RUN npm ci

EXPOSE 8080

# content/ is mounted as a volume in dev
CMD ["npx", "quartz", "build", "--serve", "--port", "8080"]


# ── build stage ───────────────────────────────────────────────────────────────
FROM dev AS build

COPY content/ /quartz/content/
RUN npx quartz build


# ── prod stage ────────────────────────────────────────────────────────────────
FROM nginx:alpine AS prod

COPY --from=build /quartz/public /usr/share/nginx/html

EXPOSE 80
