#!/usr/bin/env bash
# exit on error
set -o errexit

# Skip development/test gems (capybara, selenium, chromedriver cause build failures
# on Render because they try to download Chrome binaries)
bundle config set without 'development test'
bundle install --jobs 4 --retry 3
npm install
npm run build
bundle exec rake assets:precompile
bundle exec rake assets:clean
bundle exec rake db:migrate
# rails db:seed  # disabled: requires AWS S3 access via Rails credentials (master.key not available in this fork)
