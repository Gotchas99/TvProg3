#!/bin/bash

set -euo pipefail

set -a; . ./.env; set +a

# Swarm: build with the stack files, then deploy
docker compose build
docker compose push

docker stack deploy -c compose.yaml -c stack.yaml --detach=false tvprog3
