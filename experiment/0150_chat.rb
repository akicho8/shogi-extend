#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

ChatArticle.destroy_all
ChatUser.destroy_all
ChatRoom.destroy_all
ChatMembership.destroy_all

alice = ChatUser.create!

chat_room = ChatRoom.create!    # => #<ChatRoom id: 16, created_at: "2018-04-16 05:58:17", updated_at: "2018-04-16 05:58:17">
chat_room.chat_users << alice
p chat_room.chat_memberships
chat_room.chat_users.destroy(alice)
p chat_room.chat_memberships

# chat_user = ChatUser.first      # => #<ChatUser id: 1, name: "1さん", created_at: "2018-04-15 04:31:22", updated_at: "2018-04-15 04:31:22">
# chat_article = chat_user.chat_articles.build
# chat_article.chat_room = chat_room
# chat_article = chat_user.chat_articles.create(chat_room: chat_room, body: "(body)")
# tp chat_article.errors.full_messages # => []
# 
# # chat_article.includes(:chat_user).attributes # => 
# 
# chat_article.to_json(include: [:chat_user, :chat_room]) # => 
# # 
# >> #<ActiveRecord::Associations::CollectionProxy [#<ChatMembership id: 9, chat_room_id: 16, chat_user_id: 16, created_at: "2018-04-16 05:58:17", updated_at: "2018-04-16 05:58:17">]>
# >> #<ActiveRecord::Associations::CollectionProxy []>
