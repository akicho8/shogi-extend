#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

# Swars::Battle.user_import(user_key: "devuser1")

Swars::Membership.find_each(&:save!)

tp Swars::Membership
