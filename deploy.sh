#!/bin/bash
set -e
bundle install --deployment
bundle exec cap -s revision=$SHA $ENVIRONMENT deploy
