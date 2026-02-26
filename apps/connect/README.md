# Connect

Real-time messaging for SoundAdvice, powered by [Matrix](https://matrix.org/).

## Components

| Component       | Description                         | Directory  |
| --------------- | ----------------------------------- | ---------- |
| **Tuwunel**     | Matrix homeserver                   | `tuwunel/` |
| **Element Web** | Matrix client (branded UI)          | `element/` |
| **Supabase**    | OAuth 2.1 / OpenID Connect provider | External   |

## Project structure

```
connect/
├── tuwunel/
│   ├── docs/
│   │   ├── limitations.md           # Known limitations (media, file size)
│   │   ├── local-setup.md           # Full local dev guide
│   │   ├── production-setup.md      # Production deployment (Hetzner VPS)
│   │   └── supabase-oauth.md        # SSO flow documentation
│   ├── docker-compose.yml           # Base service definition
│   ├── docker-compose.dev.yml       # Dev override (network_mode: host)
│   ├── docker-compose.prod.yml      # Prod override
│   ├── tuwunel.toml                 # Dev config
│   ├── tuwunel.prod.toml            # Prod config
│   ├── .client_secret               # OAuth client secret (gitignored)
│   └── .client_secret.example       # Secret template
├── element/
│   ├── docs/
│   │   └── production-setup.md      # Production deployment (Cloudflare Pages)
│   ├── build.sh                     # Extract static files for production
│   ├── docker-compose.yml           # Base service definition
│   ├── docker-compose.dev.yml       # Dev override (build local)
│   ├── docker-compose.prod.yml      # Prod override
│   ├── Dockerfile                   # Dev image
│   ├── Dockerfile.prod              # Prod image
│   ├── config.json                  # Dev Element config
│   ├── config.prod.json             # Prod Element config
│   ├── index.html                   # Custom landing page
│   └── favicon.png                  # Custom favicon
└── README.md
```

## Quick start

### 1. Configure secrets

```bash
cp tuwunel/.client_secret.example tuwunel/.client_secret
```

Edit `tuwunel/.client_secret` with your Supabase OAuth client secret.

### 2. Start Tuwunel

```bash
cd tuwunel
docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d
```

Tuwunel runs on `http://localhost:8008`.

### 3. Start Element Web

```bash
cd element
docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d
```

Element Web runs on `http://localhost:8080`.

### Production

Each component is deployed independently:

- **Tuwunel** runs as a native `.deb` install on a Hetzner VPS with Caddy as a reverse proxy. See [tuwunel/docs/production-setup.md](tuwunel/docs/production-setup.md).
- **Element Web** is deployed as static files on Cloudflare Pages (zero runtime cost, free egress, global CDN). See [element/docs/production-setup.md](element/docs/production-setup.md).

## Deployment architecture

| Component         | Platform         | Notes                                                   |
| ----------------- | ---------------- | ------------------------------------------------------- |
| **Tuwunel**       | Hetzner VPS      | Native `.deb` install, managed by systemd               |
| **Caddy**         | Hetzner VPS      | Reverse proxy with automatic TLS                        |
| **Element Web**   | Cloudflare Pages | Static SPA, zero runtime cost, free egress              |
| **Supabase**      | Supabase Cloud   | OAuth 2.1 / OpenID Connect                              |
| **Media storage** | Cloudflare R2    | Mounted via GeeseFS (FUSE), managed by systemd          |
| **DNS**           | Vercel           | `matrix` A record pointing to the VPS public IP         |
| **.well-known**   | Vercel           | Matrix delegation files served from the landing project |

## Documentation

### Tuwunel (Matrix homeserver)

- [Local development setup](tuwunel/docs/local-setup.md)
- [Production deployment (Hetzner VPS)](tuwunel/docs/production-setup.md)
- [SSO flow and OAuth details](tuwunel/docs/supabase-oauth.md)
- [Known limitations](tuwunel/docs/limitations.md)

### Element Web (Matrix client)

- [Production deployment (Cloudflare Pages)](element/docs/production-setup.md)
