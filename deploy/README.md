# Deploy — bot antispam

Two instances of [qa-guru/tg-spam](https://github.com/qa-guru/tg-spam) on OVH VPS.

## Layout on server

```
/opt/bot_antispam/
├── .env                 # secrets (600, not in git)
├── docker-compose.yml   # synced from this repo
├── log/qa-guru/
├── log/automation/
├── var/qa-guru/         # sqlite + dynamic files
└── var/automation/
```

## First-time bootstrap

```bash
sudo mkdir -p /opt/bot_antispam/{log/qa-guru,log/automation,var/qa-guru,var/automation}
sudo chown -R debian:debian /opt/bot_antispam
cp deploy/.env.example /opt/bot_antispam/.env
chmod 600 /opt/bot_antispam/.env
# fill tokens + ADMIN_GROUP
./deploy/deploy.sh
```

## Routine deploy

```bash
cd /opt/bot_antispam
curl -fsSL https://raw.githubusercontent.com/qa-guru/bot-antispam.qa.guru/main/deploy/docker-compose.yml -o docker-compose.yml
./deploy/deploy.sh   # or bash deploy/deploy.sh from clone
```

`deploy.sh` pulls `ghcr.io/qa-guru/tg-spam:${TGSPAM_IMAGE_TAG:-latest}` and recreates containers. Volumes (`var/`, `log/`) are preserved.

## Groups

| Service | `TELEGRAM_GROUP` | Chat |
|---------|------------------|------|
| `tg-spam-qa-guru` | `qa_guru_chat` | QA.GURU main chat |
| `tg-spam-automation` | `qa_automation` | QA automation chat |

Both bots post moderation events to `ADMIN_GROUP` (numeric supergroup id, e.g. «QA.GURU | Spam»).

## Image

Default: `ghcr.io/qa-guru/tg-spam:latest` (built from fork on push to `master`).

Override: `export TGSPAM_IMAGE=ghcr.io/qa-guru/tg-spam:master` before deploy.
