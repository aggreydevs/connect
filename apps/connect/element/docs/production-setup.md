# Production Setup (Element Web on Cloudflare Pages)

This document covers how to build and deploy Element Web as a static site on Cloudflare Pages.

---

## Why Static Hosting?

Element Web is a pure single-page application -- HTML, CSS, and JavaScript with zero server-side logic. The official Docker image (`vectorim/element-web`) is just nginx serving static files.

Running it in a container means paying for a persistent nginx process (~50-100MB RAM) that does nothing beyond file serving. Deploying to a static hosting platform instead provides:

- **Zero runtime cost** -- no container, no RAM, no CPU
- **Free egress** -- Cloudflare Pages includes unlimited bandwidth at no cost
- **Global CDN** -- files served from edge locations closest to the user
- **No infrastructure to manage** -- no container restarts, no health checks

---

## Prerequisites

- Docker (to extract static files from the official Element Web image)
- A Cloudflare account with Pages enabled
- The `connect.soundadvice.club` domain configured in Cloudflare

---

## 1. Build Static Files

From the `element/` directory, run the build script:

```bash
cd element
bash build.sh
```

Or using the package script:

```bash
pnpm build:prod
```

This does the following:

1. Builds the Docker image using `Dockerfile.prod` (copies `config.prod.json`, `index.html`, and `favicon.png` over the official Element Web image)
2. Creates a temporary container and extracts the `/app` directory to `./dist/`
3. Removes the temporary container and image

The result is a `dist/` directory containing the full Element Web static site with your custom configuration baked in.

---

## 2. Deploy to Cloudflare Pages

### Option A: Connect via Git

1. In the Cloudflare Dashboard, go to **Pages** and create a new project
2. Connect your GitHub repository
3. Configure the build settings:

| Setting              | Value                  |
| -------------------- | ---------------------- |
| **Root directory**   | `apps/connect/element` |
| **Build command**    | `bash build.sh`        |
| **Output directory** | `dist`                 |

4. Add a custom domain: `connect.soundadvice.club`

> [!NOTE]
> Cloudflare Pages needs Docker available during the build step. If the Cloudflare build environment does not support Docker, use Option B instead.

### Option B: Direct upload

1. Run the build locally:

```bash
cd element
bash build.sh
```

2. In the Cloudflare Dashboard, go to **Pages** and create a new project
3. Choose **Direct Upload** and upload the `dist/` directory
4. Add a custom domain: `connect.soundadvice.club`

For subsequent deploys, you can use the Wrangler CLI:

```bash
npx wrangler pages deploy dist --project-name=soundadvice-connect
```

---

## 3. Verify

After deployment, verify Element Web loads correctly:

```bash
curl -I https://connect.soundadvice.club
```

Open `https://connect.soundadvice.club` in a browser. It should:

1. Load the Element Web interface with the SoundAdvice branding
2. Immediately redirect to the Supabase SSO login (configured via `sso_redirect_options.immediate: true` in `config.prod.json`)

---

## Configuration Reference

The production config (`config.prod.json`) points Element Web to the Tuwunel homeserver:

| Setting                 | Value                             |
| ----------------------- | --------------------------------- |
| **Homeserver base URL** | `https://matrix.soundadvice.club` |
| **Server name**         | `soundadvice.club`                |
| **SSO redirect**        | Immediate (no login form shown)   |
| **Theme**               | Dark                              |
| **Registration**        | Disabled                          |
| **Custom URLs**         | Disabled                          |

See `config.prod.json` for the full configuration.
