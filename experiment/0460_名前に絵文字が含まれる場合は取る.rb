#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)
Dir.chdir Rails.root

Colosseum::User.create!(name: "a🦐b").name # => "a🦐b"
