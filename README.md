Gotify self-hosted push notification server for Cloud in a Bottle. Runs as a single Docker container with SQLite.

## How it works

On first boot, the container:
1. Creates persistent directories for the database, images, and plugins
2. Generates and persists an admin password
3. Starts Gotify with the correct configuration

## Deploying

```bash
oh app deploy https://github.com/imbue-ai/openhost-gotify --wait
```

The app will be available at `gotify.{zone_domain}`.

## Admin credentials

- Username: `admin`
- Password: stored in `$OPENHOST_APP_DATA_DIR/.admin_password`

Retrieve the password from the container logs on first boot or via the file browser app.

## Pushing messages

Create an application in the Gotify web UI, then push messages with curl:

```bash
curl "https://gotify.{zone_domain}/message?token=<apptoken>" \
  -F "title=Hello" -F "message=World" -F "priority=5"
```

## Data

All persistent data lives in `$OPENHOST_APP_DATA_DIR/`:
- `data/gotify.db` — SQLite database (users, apps, messages)
- `images/` — uploaded application images
- `plugins/` — Gotify plugins

## Resources

Needs ~256MB RAM and 0.25 CPU cores. Very lightweight.

## Files

- `Dockerfile` — extends official Gotify server image
- `start.sh` — configures Gotify via env vars, generates admin password, launches server
- `openhost.toml` — Cloud in a Bottle app manifest
