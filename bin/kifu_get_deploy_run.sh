#!/bin/sh
cap production deploy:upload FILES=bin/kifu_get.rb
ssh i 'cd /var/www/shogi_web_production/current/bin; RAILS_ENV=production ruby ./kifu_get.rb'
