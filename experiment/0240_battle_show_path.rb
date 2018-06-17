#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

user = Fanta::User.create!
battle = OwnerRoom.create!
ActionController::Base.relative_url_root = "/shogi"
battle.show_path             # => "/shogi/online/battles/14"
