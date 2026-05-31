# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this project is

**Daria AI — English Studio** is a single-page **static marketing landing page**
for an English-tutoring studio based in Tomsk, offering online and offline
lessons for children, teenagers, and adults. The entire site is one file:
`index.html`.

The page content is in **Russian** (`<html lang="ru">`), with a few English
brand/marketing tokens ("Daria AI", "English Studio", "Tomsk", "Online",
"Telegram"). Preserve the Russian copy and `lang="ru"` when editing.

## Architecture

The whole site is **one self-contained file**, `index.html` (~9 KB):

- Semantic HTML5 (`<header>`, `<main>`, `<section>`, `<footer>`).
- **All CSS is inlined** in a single `<style>` block in `<head>`, using `:root`
  custom properties (dark theme + cyan/violet accents), gradient backgrounds,
  flex/grid card layouts, and one `@media (max-width: 900px)` breakpoint. Fonts
  are the system Arial/Helvetica stack — no web-font CDN.
- **No JavaScript at all** (no `<script>` tags), **no framework, no build step,
  no dependencies, no external CDN, no forms, no API/fetch calls, no analytics.**
- The only interactivity is links: in-page anchors to `#contact` ("Записаться" /
  "Получить консультацию") and one external Telegram link. ⚠️ That Telegram href
  is a bare placeholder `https://t.me/` with no username — fill in the real
  handle before launch.

Page structure: sticky `<header>` (logo + "Записаться") → hero (badge "English
Studio • Tomsk • Online", `<h1>` «Английский без страха и скуки», lead, CTA, and
a card of three highlights) → section «Что вы получите» (3 cards) → section «Кому
подходит» (3 cards) → `#contact` CTA «Начните с первого шага» (Telegram link) →
`<footer>`.

**The established convention is "keep it self-contained."** When changing the
site, edit `index.html` directly and keep CSS inlined rather than introducing
separate asset files, a bundler, or a framework, unless explicitly asked to.

## Build / run / test

There is **no build system, package manager, linter, or test suite** — none is
needed for a single static HTML file.

To preview locally, open `index.html` directly in a browser, or serve it:

```bash
python3 -m http.server 8000   # then open http://localhost:8000
```

## Deployment

`.github/workflows/deploy.yml` ("Deploy site to VPS") runs on every push to the
**`main`** branch and deploys to a **self-managed VPS over SSH**, not GitHub
Pages (note: the page footer text says "GitHub Pages", which is misleading — the
actual target is a VPS):

1. Checkout (`actions/checkout@v4`).
2. Set up SSH — writes `secrets.SSH_PRIVATE_KEY` to `~/.ssh/id_ed25519` and
   `secrets.KNOWN_HOSTS` to `~/.ssh/known_hosts`.
3. `rsync -avz --delete ./ <USERNAME>@<HOST>:<APP_DIR>/` (excluding `.git` and
   `.github`), then `ssh ... "systemctl reload nginx"`.

The remote nginx serves the contents of `APP_DIR`. **The `--delete` flag mirrors
the repo root onto `APP_DIR`**, so any stray file in `APP_DIR` is removed on each
deploy — keep the repo root limited to what should be publicly served.

Required GitHub Actions **secrets**: `SSH_PRIVATE_KEY`, `KNOWN_HOSTS`,
`USERNAME`, `HOST`, `APP_DIR`. No credentials are hardcoded in the workflow.

> Note: because `rsync` copies the repo root, the non-site files listed below
> are excluded only by `.git`/`.github` filters being absent — currently they
> *would* be pushed to the web root. This is another reason to clean them up.

## Repository hygiene (important)

The repository tracks several files that normally should **not** be committed and
are unrelated to the site:

- `.ssh/dariaeai_deploy` — a **private SSH deploy key** (plus
  `.ssh/dariaeai_deploy.pub`, `.ssh/authorized_keys`, `.ssh/known_hosts`)
- `.bash_history`, `.bashrc`, `.profile`, `.gitconfig`
- `.cache/motd.legal-displayed`

The committed private key is a credential-exposure risk (and, per the deploy
step above, these files would also be rsync'd to the public web root). Do not add
more such files. If you restructure the repo, remove these from version control
and add a `.gitignore` — but treat the key as potentially compromised and flag it
rather than silently deleting it.
