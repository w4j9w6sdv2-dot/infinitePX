#!/usr/bin/env bash
# Script di avvio per il container Docker su Render
set -o errexit

cd /app

# Esegui le migrazioni del DB (idempotente)
echo ">>> Running database migrations..."
bundle exec rake db:migrate

# Avvia Puma
echo ">>> Starting Puma..."
exec bundle exec puma -C config/puma.rb
