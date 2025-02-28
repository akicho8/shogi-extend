#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)

# Swars::Importer::FullHistoryImporter.new(user_key: "DevUser1").call

Swars::Membership.find_each(&:save!)

# ruby 2.7.0 にすると動かない
tp Swars::Membership
