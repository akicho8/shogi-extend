#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)

# Swars::Importer::AllRuleImporter.new(user_key: "DevUser1").run

Swars::Membership.find_each(&:save!)

# ruby 2.7.0 にすると動かない
tp Swars::Membership
