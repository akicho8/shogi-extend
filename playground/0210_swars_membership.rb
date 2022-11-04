#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

# Swars::Importer::UserImporter.new(user_key: "devuser1").run

Swars::Membership.find_each(&:save!)

# ruby 2.7.0 にすると動かない
tp Swars::Membership
