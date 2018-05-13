#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

user = ChatUser.create!
chat_room = user.owner_rooms.create!
ActionController::Base.relative_url_root = "/shogi"
chat_room.show_path             # => "/shogi/online/battles/14"
