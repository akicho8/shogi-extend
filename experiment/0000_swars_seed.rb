#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

Swars::User.destroy_all
Swars::Battle.destroy_all

user = Swars::User.create!
3.times do
  Swars::Battle.create! do |e|
    e.memberships.build(user: user)
  end
end
