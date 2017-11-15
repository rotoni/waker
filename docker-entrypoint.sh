#!/bin/bash
cd /app
bundle exec rake db:migrate RAILS_ENV=$RAILS_ENV

exec "$@"
