#!/usr/bin/env bash
set -o errexit

echo "=== STEP1: bundle config ==="
bundle config set without 'development test'
bundle config set path vendor/bundle

echo "=== STEP2: bundle install ==="
bundle install --jobs 4 --retry 3

echo "=== STEP3: npm install + build ==="
npm install
npm run build

echo "=== STEP4: assets precompile ==="
bundle exec rake assets:precompile
bundle exec rake assets:clean

echo "=== STEP5: db migrate ==="
bundle exec rake db:migrate

echo "=== DONE ==="
