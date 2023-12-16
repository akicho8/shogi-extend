require File.expand_path('../../../config/environment', __FILE__)
ShareBoard.setup(force: true)

ShareBoard::MessageScope.count  # => 2

User.create!

login_user = User.create!

user = ShareBoard::User.create!

ShareBoard::Room.simple_say

# room = ShareBoard::Room.create!(key: "dev_room")
# room.receive_and_bc({
#                       # "from_connection_id"=>"Ea29TwGfUbD",
#                       "from_user_name" => "alice",
#                       "real_user_id" => User.bot.id,
#                       # "performed_at"=>1702177627002,
#                       # "ua_icon_key"=>"mac",
#                       # "ac_events_hash"=>{"initialized"=>1},
#                       # "debug_mode_p"=>true,
#                       "message_scope_key"=>"ms_private",
#                       "message"=>"jkjk",
#                       # "action"=>"message_share",
#                     })

# chat_message = user.chat_messages.create!(room: room, content: "a")  # => #<ShareBoard::ChatMessage id: 1, room_id: 1, user_id: 1, message_scope_id: 1, content: "a", performed_at: 1702462991374, created_at: "2023-12-13 19:23:11.000000000 +0900", updated_at: "2023-12-13 19:23:11.000000000 +0900", real_user_id: nil, from_connection_id: nil, primary_emoji: nil>
# chat_message = room.chat_messages.create!(user: user, content: "a")  # => #<ShareBoard::ChatMessage id: 2, room_id: 1, user_id: 1, message_scope_id: 1, content: "a", performed_at: 1702462991385, created_at: "2023-12-13 19:23:11.000000000 +0900", updated_at: "2023-12-13 19:23:11.000000000 +0900", real_user_id: nil, from_connection_id: nil, primary_emoji: nil>
#
# chat_message.user        # => #<ShareBoard::User id: 1, name: "user1", memberships_count: 0, created_at: "2023-12-13 19:23:11.000000000 +0900", updated_at: "2023-12-13 19:23:11.000000000 +0900", chat_messages_count: 2>
# chat_message.room        # => #<ShareBoard::Room id: 1, key: "dev_room", battles_count: 0, created_at: "2023-12-13 19:23:11.000000000 +0900", updated_at: "2023-12-13 19:23:11.000000000 +0900", chat_messages_count: 2>
#
# chat_message.real_user = login_user
# chat_message.save!
# chat_message.real_user   # => #<User id: 25, key: "8255324e454df7ac390074bfde8fc8de", name: "", user_agent: "", race_key: "human", name_input_at: nil, created_at: "2023-12-13 19:23:11.000000000 +0900", updated_at: "2023-12-13 19:23:11.000000000 +0900", email: "8255324e454df7ac390074bfde8fc8de@localhost", permit_tag_list: nil>
#
# room.chat_messages_count # => 2
# user.chat_messages_count # => 2
#
# room.chat_messages       # => #<ActiveRecord::Associations::CollectionProxy [#<ShareBoard::ChatMessage id: 1, room_id: 1, user_id: 1, message_scope_id: 1, content: "a", performed_at: 1702462991374, created_at: "2023-12-13 19:23:11.000000000 +0900", updated_at: "2023-12-13 19:23:11.000000000 +0900", real_user_id: nil, from_connection_id: nil, primary_emoji: nil>, #<ShareBoard::ChatMessage id: 2, room_id: 1, user_id: 1, message_scope_id: 1, content: "a", performed_at: 1702462991385, created_at: "2023-12-13 19:23:11.000000000 +0900", updated_at: "2023-12-13 19:23:11.000000000 +0900", real_user_id: 25, from_connection_id: nil, primary_emoji: nil>]>
# room.chat_users          # => #<ActiveRecord::Associations::CollectionProxy [#<ShareBoard::User id: 1, name: "user1", memberships_count: 0, created_at: "2023-12-13 19:23:11.000000000 +0900", updated_at: "2023-12-13 19:23:11.000000000 +0900", chat_messages_count: 2>, #<ShareBoard::User id: 1, name: "user1", memberships_count: 0, created_at: "2023-12-13 19:23:11.000000000 +0900", updated_at: "2023-12-13 19:23:11.000000000 +0900", chat_messages_count: 2>]>
#
# chat_message.message_scope_key = :ms_private
#
# tp chat_message

# room.chat_messages_mock_setup(10, user: user)
# # room.chat_messages.destroy_all
# # 10.times do |i|
# #   room.chat_messages.create!(user: user, content: "(#{i})")
# # end
# room.chat_messages.count        # => 10
# tp room.chat_messages

# ~> /Users/ikeda/src/shogi-extend/app/models/share_board/broadcaster.rb:32:in `validate!': 値が nil のキーがある : {"real_user_id"=>nil} (ArgumentError)
# ~>    from /Users/ikeda/src/shogi-extend/app/models/share_board/broadcaster.rb:21:in `call'
# ~>    from /Users/ikeda/src/shogi-extend/app/models/share_board/chat_message.rb:68:in `broadcast_to_all'
# ~>    from /Users/ikeda/src/shogi-extend/app/models/share_board/room.rb:125:in `receive_and_bc'
# ~>    from -:11:in `<main>'
