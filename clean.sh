#!/bin/sh
# cap staging bundler:clean
# ssh s 'find /var/www/shogi_web_staging/shared/bundle/ruby/2.6.0/gems | grep rmagick'
# ssh s 'rm -fr /var/www/shogi_web_staging/shared/bundle/ruby/2.6.0/gems/rmagick*'
# ssh s 'rm -fr /var/www/shogi_web_staging/shared/bundle/ruby/2.6.0/extensions/x86_64-linux/2.6.0/rmagick-4.2.2'
# ssh s 'rm -fr /var/www/shogi_web_staging/shared/bundle/ruby/2.6.0/specifications/rmagick-4.2.2.gemspec'
# cap staging bundler:install
