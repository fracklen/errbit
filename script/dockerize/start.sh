#!/bin/bash

bundle exec rake assets:precompile

exec bundle exec unicorn_rails -E production -c config/unicorn.rb



