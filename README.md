# Randomly Delete Message

Make your discord bot randomly delete messages

## Installation

### Pre-requisites

1. Docker installed

### Steps (Command line)

1. Run ```docker pull summerwya/randomly-delete-message```
2. Then ```docker run -d --name randomly-delete-bot -e DISCORD_BOT_TOKEN="your_token_here" -e CHANCE=20 --restart on-failure summerwya/randomly-delete-message:latest```
3. Done

### Steps (Compose)

1. Download [compose.yaml](compose.yaml)
2. Put it inside a folder
3. Configure the `environment` to suit your bot
4. Open that folder inside a terminal
5. Run `docker compose pull`
6. Run `docker compose up -d`
   - *Run without `-d` and it won't be running in the background*