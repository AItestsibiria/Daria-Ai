# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Current state of the repository

This repository is at the **initial / planning stage**. As of this writing the
only tracked file is `README.md` — there is **no source code, build system,
dependency manifest, test suite, CI configuration, or linter setup yet**.

Consequently, this file documents the project's *intent* and the conventions to
follow as code is introduced. There are intentionally **no build/lint/test
commands listed below**, because none exist yet. When the first real code lands,
update this section with the actual commands (how to install dependencies, run
the app, run the full test suite, and run a single test).

## What the project is

**Daria-Ai** is a voice AI assistant named "Дарья" (Daria) for handling
**incoming phone calls**. The system is intended to recognize the caller's
speech, understand context, and respond by voice in real time, in order to
automate the processing of inbound telephony.

The README is written in Russian; Russian is the project's primary language for
both documentation and the assistant's spoken interaction. Preserve Cyrillic
text exactly when editing files.

## Intended functional scope

The README describes the following planned capabilities. Treat these as the
high-level domains the codebase will be organized around:

- **Speech-to-Text (STT)** — recognizing the caller's speech.
- **Text-to-Speech (TTS)** — synthesizing the assistant's voice responses.
- **Natural Language Processing (NLP)** — understanding intent and context.
- **Telephony integration (SIP/VoIP)** — connecting to phone infrastructure to
  receive and handle calls.
- **Scenario-driven dialogue** — conducting conversations according to defined
  scripts/scenarios.
- **Call recording & analytics** — recording calls and analyzing them.

A real-time inbound voice assistant typically wires these together as a
pipeline: telephony (SIP/VoIP) → STT → NLP/dialogue manager → TTS → telephony,
with latency being a first-class concern. Keep that end-to-end audio loop in
mind when adding components.

## Guidance for future changes

- Because the project is greenfield, when you establish foundational choices
  (language/runtime, framework, STT/TTS/NLP providers, telephony stack,
  dependency manager, test runner), **record them here** so later sessions
  inherit the decisions rather than re-deriving them.
- The README's "Технологии" (Technologies), "Установка" (Installation), and
  "Лицензия" (License) sections are placeholders marked "(раздел в разработке)".
  When you implement the corresponding pieces, fill in both the README and the
  relevant section of this file.
