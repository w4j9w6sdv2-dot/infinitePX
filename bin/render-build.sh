#!/usr/bin/env bash
set -o errexit

echo "=== STEP1: bundle config ==="
bundle config set without 'development test'
bundle config set path vendor/bundle

echo "=== STEP2: bundle install ==="
bundle install --jobs 4 --retry 3 2>&1 | tail -50

echo "=== STEP3: verifying ==="
bundle list | head -30

echo "=== DONE ==="
