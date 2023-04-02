#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)

room = ShareBoard::Room.fetch("dev_room")
room.battles                    # => #<ActiveRecord::Associations::CollectionProxy [#<ShareBoard::Battle id: 6, room_id: 9, key: "62300f7ea354c670d5c45a81d080e386", title: "共有将棋盤", sfen: "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPP...", turn: 0, created_at: "2023-03-26 18:42:42.000000000 +0900", updated_at: "2023-03-26 18:42:42.000000000 +0900">]>
