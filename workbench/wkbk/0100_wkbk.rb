#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

# Wkbk::Article.destroy_all

# user = User.admin
# params = {
#   "article" => {
#     "init_sfen" => "4k4/9/4GG3/9/9/9/9/9/9 b 2r2b2g4s4n4l18p 1",
#     "moves_answers"=>[{"moves_str"=>"4c5b"}],
#     "time_limit_clock"=>"1999-12-31T15:03:00.000Z",
#   },
# }.deep_symbolize_keys
#
# article = user.wkbk_articles.find_or_initialize_by(id: params[:article][:id])
# article.update_from_action(params)
# article
# article.moves_answers.collect{|e|e.moves_str} # => ["4c5b"]

# lobby = Wkbk::LobbyChannel.new
# lobby                           # =>

#   article = user.wkbk_articles.create! do |e|
#     e.init_sfen = "4k4/9/4G4/9/9/9/9/9/P8 b G2r2b2g4s4n4l#{i+1}p 1"
#     e.moves_answers.build(moves_str: "G*5b")
#     e.endpos_answers.build(end_sfen: "4k4/4G4/4G4/9/9/9/9/9/9 w 2r2b2g4s4n4l18p 2")
#     e.updated_at = Time.current - 1.days + i.hours
#   end

# user = User.create!
# article = user.wkbk_articles.create! do |e|
#   e.init_sfen = "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1"
#   e.moves_answers.build(moves_str: "G*5b")
#   e.endpos_answers.build(end_sfen: "4k4/4G4/4G4/9/9/9/9/9/9 w 2r2b2g4s4n4l18p 2")
# end

# user = User.admin
# 11.times do |i|
#   article = user.wkbk_articles.create! do |e|
#     e.init_sfen = "4k4/9/4G4/9/9/9/9/9/P8 b G2r2b2g4s4n4l#{i+1}p 1"
#     e.moves_answers.build(moves_str: "G*5b")
#     e.endpos_answers.build(end_sfen: "4k4/4G4/4G4/9/9/9/9/9/9 w 2r2b2g4s4n4l18p 2")
#     e.updated_at = Time.current - 1.days + i.hours
#   end
# end
# Wkbk::Article.count           # => 11

# tp article
# tp article.moves_answers
# tp article.endpos_answers

# hash = article.attributes.slice("id", "user_id", "init_sfen", "time_limit_sec")
# hash                            # => {"id"=>7, "user_id"=>16, "init_sfen"=>"4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1", "time_limit_sec"=>nil, "title"=>nil, "description"=>nil, "hint_desc"=>nil, "source_author"=>nil, "source_author_link"=>nil, "created_at"=>Mon, 20 Apr 2020 23:02:00 JST +09:00, "updated_at"=>Mon, 20 Apr 2020 23:02:00 JST +09:00, "o_count"=>0, "x_count"=>0}

# hash = article.attributes
# hash = hash.merge(moves_answers: article.moves_answers)
# tp hash.as_json

# Wkbk::Battle.destroy_all

# user1 = User.create!
# user2 = User.create!
#
# battle = Wkbk::Battle.create! do |e|
#   e.memberships.build(user: user1, judge_key: "win")
#   e.memberships.build(user: user2, judge_key: "lose")
# end

# battle.messages.create!(user: user1, body: "a") # => #<Wkbk::Message id: 4, user_id: 19, battle_id: 4, body: "a", created_at: "2020-05-05 14:45:49", updated_at: "2020-05-05 14:45:49">
# tp user1.wkbk_season_xrecord.update!(rating: 1600)
# tp user1.wkbk_season_xrecord

# def initialize(connection, identifier, params = {})
# Wkbk::BattleChannel.new(nil, nil, a: 1) # =>


article = Wkbk::Article.first
tp article.as_json(include: [:user, :moves_answers])
# ~> /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require': cannot load such file -- /Users/ikeda/src/shogi/shogi-extend/workbench/config/environment (LoadError)
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require'
# ~> 	from -:2:in `<main>'
