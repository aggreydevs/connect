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
│   ├── docker-compose.yml           # Base service definition
│   ├── docker-compose.dev.yml       # Dev override (network_mode: host)
│   ├── docker-compose.prod.yml      # Prod override
│   ├── tuwunel.toml                 # Dev config
│   ├── tuwunel.prod.toml            # Prod config
│   ├── .client_secret               # OAuth client secret (gitignored)
│   └── .client_secret.example       # Secret template
├── element/
│   ├── docker-compose.yml           # Base service definition
│   ├── docker-compose.dev.yml       # Dev override (build local)
│   ├── docker-compose.prod.yml      # Prod override
│   ├── Dockerfile                   # Dev image
│   ├── Dockerfile.prod              # Prod image
│   ├── config.json                  # Dev Element config
│   ├── config.prod.json             # Prod Element config
│   ├── index.html                   # Custom landing page
│   └── favicon.png                  # Custom favicon
└── docs/
    ├── local-setup.md               # Full local dev guide
    ├── production-setup.md          # Production deployment guide (Hetzner VPS)
    └── supabase-oauth.md            # SSO flow documentation
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

In production, Tuwunel runs as a native `.deb` install on a Hetzner VPS with Caddy as a reverse proxy (not Docker). See [docs/production-setup.md](docs/production-setup.md) for the full step-by-step deployment guide.

## Deployment architecture

| Component       | Platform       | Notes                                                   |
| --------------- | -------------- | ------------------------------------------------------- |
| **Tuwunel**     | Hetzner VPS    | Native `.deb` install, managed by systemd               |
| **Caddy**       | Hetzner VPS    | Reverse proxy with automatic TLS                        |
| **Element Web** | Vercel         | Static SPA, deployed independently                      |
| **Supabase**    | Supabase Cloud | OAuth 2.1 / OpenID Connect                              |
| **DNS**         | Vercel         | `matrix` A record pointing to the VPS public IP         |
| **.well-known** | Vercel         | Matrix delegation files served from the landing project |

## Documentation

- [Local development setup](docs/local-setup.md)
- [Production deployment](docs/production-setup.md)
- [SSO flow and OAuth details](docs/supabase-oauth.md)
