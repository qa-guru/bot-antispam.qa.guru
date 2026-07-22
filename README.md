# bot-antispam.qa.guru

Production deploy for Telegram anti-spam bots (`@qa_guru_chat`, `@qa_automation`).

| Компонент | GitHub | Роль |
|-----------|--------|------|
| **tg-spam** | [qa-guru/tg-spam](https://github.com/qa-guru/tg-spam) | Fork [umputun/tg-spam](https://github.com/umputun/tg-spam) → Docker image `ghcr.io/qa-guru/tg-spam` |
| **этот репозиторий** | [qa-guru/bot-antispam.qa.guru](https://github.com/qa-guru/bot-antispam.qa.guru) | Compose, deploy scripts, CI |

## Хост

| | |
|---|---|
| **Provider** | OVH VPS (EU) — Telegram API недоступен из Selectel RU |
| **Path** | `/opt/bot_antispam` |
| **User** | `debian` (uid 1000) |

## Быстрый старт

| Действие | Как |
|----------|-----|
| **Ручной деплой** | Actions → [deploy](.github/workflows/deploy.yml) → Run workflow |
| **На сервере** | `./deploy/deploy.sh` (из клона или после curl из CI) |
| **Smoke** | `./deploy/smoke-remote.sh` |

Подробности: [`deploy/README.md`](deploy/README.md).

## Секреты

На сервере: `/opt/bot_antispam/.env` (не в git). Шаблон: [`deploy/.env.example`](deploy/.env.example).

GitHub Actions (environment `bot-antispam-production`):

- `BOT_ANTISPAM_DEPLOY_HOST` — OVH IP
- `BOT_ANTISPAM_DEPLOY_USER` — `debian`
- `BOT_ANTISPAM_DEPLOY_KEY` — SSH private key

Optional: `BOT_ANTISPAM_DISPATCH_TOKEN` в [qa-guru/tg-spam](https://github.com/qa-guru/tg-spam) — auto-deploy после push образа.
