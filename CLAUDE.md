# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this project is

**Daria AI** is a single-page **static marketing landing page** for an AI-powered
English-tutoring service aimed at Russian-speaking IT specialists and
professionals. The entire site is one file: `index.html`.

The page content is in **Russian** (`<html lang="ru">`); the brand name
("Daria AI") and a few words like "Pro" are in Latin script. Preserve the
Russian copy and the `lang="ru"` attribute when editing.

## Architecture

The whole site is **one self-contained file**, `index.html` (~9 KB):

- Semantic HTML5 (`<header>`, `<section>`, `<footer>`).
- **All CSS is inlined** in a single `<style>` block, using `:root` CSS custom
  properties, gradients, flex/grid card layouts, and media queries for
  responsiveness.
- **Minimal inline JavaScript** — only smooth-scroll behavior for the on-page
  anchor navigation. There is no data logic.
- **No framework, no build step, no dependencies, no external CDN links, no
  external scripts, no forms, no API/fetch calls, no analytics.** Everything is
  inlined.

Page sections (h2): «Почему Daria AI?» (Why), «Как это работает» (How it works),
«Тарифы» (Pricing — tiers Старт / Профи·Pro / Премиум), «Готовы начать?» (CTA).
The CTA buttons are plain anchor links (`href="#..."`) — there is no signup form
or backend.

**The established convention is "keep it self-contained."** When changing the
site, edit `index.html` directly and keep styles/scripts inlined rather than
introducing separate asset files, a bundler, or a framework, unless explicitly
asked to change that approach.

## Build / run / test

There is **no build system, package manager, linter, or test suite** — and none
is needed for a single static HTML file.

To preview locally, either open `index.html` directly in a browser, or serve it:

```bash
python3 -m http.server 8000   # then open http://localhost:8000
```

## Deployment

`.github/workflows/deploy.yml` deploys the site to **GitHub Pages** on every
push to the **`main`** branch, using the official Pages actions
(`actions/configure-pages`, `actions/upload-pages-artifact` with `path: '.'`,
and `actions/deploy-pages`). It uses the built-in `GITHUB_TOKEN`/OIDC — no
custom secrets, no SSH/rsync, no external host.

Deployment is automatic: merging/pushing to `main` publishes the site.

> ⚠️ **Known issue:** the committed `deploy.yml` is currently corrupted — the
> `name:` and `on:` stanzas are duplicated many times, which makes it invalid
> YAML. It needs to be cleaned up to the single intended workflow before it will
> run reliably.

## Repository hygiene (important)

The repository tracks several files that normally should **not** be committed
and are unrelated to the site:

- `.ssh/dariaeai_deploy` — a **private SSH deploy key** (plus
  `.ssh/dariaeai_deploy.pub`, `.ssh/authorized_keys`, `.ssh/known_hosts`)
- `.bash_history`, `.bashrc`, `.profile`, `.gitconfig`
- `.cache/motd.legal-displayed`

The committed private key is a credential-exposure risk. Do not add more such
files. If you touch repository structure, consider removing these from version
control and adding a `.gitignore` — but treat the key as potentially
compromised and flag it rather than silently deleting it.
