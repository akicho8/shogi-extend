#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

ChatArticle.destroy_all

chat_user = ChatUser.first      # => #<ChatUser id: 1, name: "1さん", created_at: "2018-04-15 04:31:22", updated_at: "2018-04-15 04:31:22">
chat_room = ChatRoom.first      # => #<ChatRoom id: 1, created_at: "2018-04-15 04:31:22", updated_at: "2018-04-15 04:31:22">
chat_article = chat_user.chat_articles.build
chat_article.chat_room = chat_room
chat_article = chat_user.chat_articles.create(chat_room: chat_room, body: "(body)")
tp chat_article.errors.full_messages # => []

# chat_article.includes(:chat_user).attributes # => 

chat_article.to_json(include: [:chat_user, :chat_room]) # => 
# ~> /usr/local/var/rbenv/versions/2.5.0/lib/ruby/gems/2.5.0/gems/activemodel-5.1.6/lib/active_model/attribute_methods.rb:432:in `method_missing': undefined method `includes' for #<ChatArticle:0x00007ff2d18bcba0> (NoMethodError)
# ~> 	from -:13:in `<main>'
