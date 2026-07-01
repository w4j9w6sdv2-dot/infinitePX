#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
npm install
npm run build
bundle exec rake assets:precompile
bundle exec rake assets:clean
bundle exec rake db:migrate
# rails db:seed  # disabled: requires AWS S3 access via Rails credentials (master.key not available in this fork)
