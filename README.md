# SoundAdvice

Monorepo for the SoundAdvice platform, managed with [Turborepo](https://turborepo.dev/) and [pnpm](https://pnpm.io/).

## Structure

```
soundadvice/
├── apps/
│   └── connect/          # Real-time messaging (Tuwunel + Element Web)
├── packages/
│   ├── eslint-config/    # Shared ESLint configuration
│   └── typescript-config/ # Shared TypeScript configuration
├── turbo.json            # Turborepo pipeline config
├── pnpm-workspace.yaml   # Workspace definitions
└── flake.nix             # Nix dev environment
```

## Prerequisites

- [Node.js](https://nodejs.org/) >= 18
- [pnpm](https://pnpm.io/) 9.x
- [Docker](https://www.docker.com/) (for `apps/connect`)

Alternatively, use the Nix dev shell:

```bash
nix develop
```

## Getting started

```bash
pnpm install
```

### Development

```bash
pnpm dev
```

### Build

```bash
pnpm build
```

### Lint & format

```bash
pnpm lint
pnpm format
```

## Apps

| App                        | Description                                                      | Docs                             |
| -------------------------- | ---------------------------------------------------------------- | -------------------------------- |
| [`connect`](apps/connect/) | Matrix-based messaging (Tuwunel homeserver + Element Web client) | [README](apps/connect/README.md) |

## Shared packages

| Package                   | Description                                |
| ------------------------- | ------------------------------------------ |
| `@repo/eslint-config`     | Shared ESLint rules (base, Next.js, React) |
| `@repo/typescript-config` | Shared `tsconfig.json` presets             |
