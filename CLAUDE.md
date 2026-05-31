# CLAUDE.md

Guidance for AI assistants (and humans) working in this repository.

## Project overview

**Daria AI — English Studio** is a single-page marketing/landing website for an
English-language tutoring studio (Tomsk, Russia; online & offline). The site
content is written in **Russian**. It is a static site with **no build step, no
dependencies, and no JavaScript framework** — just hand-written HTML and inline
CSS, deployed to a VPS behind nginx.

## Repository layout

```
index.html                  # The entire website: markup + inline <style> CSS
README.md                   # Minimal project title only
.github/workflows/deploy.yml # CI/CD: deploys to VPS on push to main
```

> Note: `origin/main` also tracks several environment/home-directory dotfiles
> (`.bashrc`, `.profile`, `.gitconfig`, `.ssh/*`, `.cache/*`, `.bash_history`).
> These are **not part of the website** and should not be edited as part of
> feature work. **Do not commit secrets** — a private SSH deploy key is currently
> tracked under `.ssh/`; treat it as sensitive and flag it rather than relying on
> it (see "Security notes").

## Architecture & conventions

The entire site lives in **`index.html`**. Keep it that way unless there is a
strong reason to split files — there is currently no asset pipeline to bundle or
reference external CSS/JS.

- **Single-file structure**: All CSS is inline in a single `<style>` block in
  `<head>`. There is no external stylesheet and no JS.
- **Design tokens via CSS custom properties**: Colors, shadows, and surfaces are
  defined as variables on `:root` (e.g. `--bg`, `--card`, `--accent`, `--btn`).
  Reuse these variables instead of hard-coding new color values, so the dark
  theme stays consistent.
- **Layout**: Centered content uses the `.wrap` container
  (`width:min(1120px, calc(100% - 32px))`). Sections use CSS grid
  (`.hero-grid`, `.grid-3`). Reusable surfaces use `.card` / `.hero-card`.
- **Responsive**: A single breakpoint at `max-width: 900px` collapses multi-column
  grids to one column. Preserve this when adding new grid sections.
- **Language & tone**: User-facing copy is **Russian**. Match the existing voice
  (warm, encouraging, plain language). Keep `<html lang="ru">` and update the
  `<meta name="description">` if the page purpose changes.
- **Accessibility/semantics**: Use semantic landmarks (`header`, `main`,
  `section`, `footer`) as the existing markup does. External links use
  `target="_blank" rel="noopener noreferrer"`.

## Development workflow

This is a static page — no install, build, or test commands exist.

- **Preview locally**: open `index.html` directly in a browser, or serve the
  folder, e.g. `python3 -m http.server` and visit `http://localhost:8000`.
- **No linters/tests/CI checks** run on pull requests. Validation is manual:
  view the page and check both desktop and mobile (≤900px) layouts.

## Deployment

Deployment is automated by `.github/workflows/deploy.yml`:

- **Trigger**: every push to the `main` branch.
- **Mechanism**: `rsync -avz --delete ./ <user>@<host>:<app_dir>/` (excluding
  `.git` and `.github`), then `systemctl reload nginx` over SSH.
- **Because of `--delete`**, anything not in the repo (except the excluded dirs)
  is removed from the server. Be careful that all required runtime files are
  committed.
- **Required GitHub Actions secrets**: `SSH_PRIVATE_KEY`, `KNOWN_HOSTS`,
  `USERNAME`, `HOST`, `APP_DIR`.

There is no staging environment — merging to `main` ships to production.

## Git conventions

- Do work on a feature branch and open a PR into `main` (do not push directly to
  `main` unless explicitly asked).
- Use short, imperative commit messages (matching existing history, e.g.
  "Add initial index.html for Daria AI English Studio").
- **Only create a pull request when explicitly requested.**

## Security notes

- A private SSH deploy key (`.ssh/dariaeai_deploy`) appears to be committed to the
  repository. This is a credential-exposure risk; do not depend on it for new
  work, avoid copying it, and recommend rotating it and removing it from history.
- Deployment relies on GitHub Actions **secrets** (above). Never hard-code these
  values or print them in workflow logs.
