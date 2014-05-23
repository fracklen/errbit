#!/bin/bash

export REDIS_URL=$REDIS_PORT

exec bundle exec unicorn_rails -E production



