#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

pp ActiveModelSerializers::SerializableResource.new(User.first).as_json
pp ActiveModelSerializers::SerializableResource.new(LobbyMessage.first).as_json
pp ActiveModelSerializers::SerializableResource.new(Colosseum::Battle.first, include: {memberships: :user}).as_json

# >> {:id=>1,
# >>  :name=>"名無しの棋士1号",
# >>  :avatar_url=>
# >>   "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBEZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--8c3f3722c03a8b111db3ede72db9bc075d026871/51587037_p15_master1200.jpg",
# >>  :joined_at=>Fri, 01 Jun 2018 16:29:36 JST +09:00,
# >>  :fighting_at=>nil,
# >>  :matching_at=>nil,
# >>  :lifetime_key=>"lifetime_m5",
# >>  :self_preset_key=>"平手",
# >>  :oppo_preset_key=>"平手",
# >>  :current_battle=>nil}
# >> {:id=>1,
# >>  :message=>"aa",
# >>  :created_at=>Tue, 29 May 2018 20:52:47 JST +09:00,
# >>  :user=>
# >>   {:id=>1,
# >>    :name=>"名無しの棋士1号",
# >>    :avatar_url=>
# >>     "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBEZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--8c3f3722c03a8b111db3ede72db9bc075d026871/51587037_p15_master1200.jpg"}}
# >> {:id=>1,
# >>  :room_owner_id=>1,
# >>  :black_preset_key=>"平手",
# >>  :white_preset_key=>"平手",
# >>  :lifetime_key=>"lifetime_m5",
# >>  :name=>"名無しの棋士1号の対戦部屋 #1",
# >>  :full_sfen=>
# >>   "position startpos moves 7g7f 5c5d 2g2f 8c8d 1g1f 9c9d 2h2g 9a9b 1i1h",
# >>  :clock_counts=>{:black=>[3, 8, 6, 62, 3], :white=>[2, 43, 4, 20]},
# >>  :turn_max=>9,
# >>  :battle_request_at=>Sun, 27 May 2018 19:58:48 JST +09:00,
# >>  :auto_matched_at=>nil,
# >>  :begin_at=>Sun, 27 May 2018 19:58:51 JST +09:00,
# >>  :end_at=>Sun, 27 May 2018 20:01:37 JST +09:00,
# >>  :last_action_key=>"ILLEGAL_MOVE",
# >>  :win_location_key=>"black",
# >>  :current_users_count=>-2,
# >>  :watch_ships_count=>0,
# >>  :countdown_flags=>{:black=>false, :white=>false},
# >>  :show_path=>"/online/battles/1",
# >>  :handicap=>false,
# >>  :human_kifu_text=>
# >>   "開始日時：2018/05/27 19:58:51\n" +
# >>   "終了日時：2018/05/27 20:01:37\n" +
# >>   "場所：http://localhost:3000/online/battles/1\n" +
# >>   "先手：名無しの棋士1号\n" +
# >>   "後手：名無しの棋士1号\n" +
# >>   "手合割：平手\n" +
# >>   "\n" +
# >>   "▲７六歩 △５四歩 ▲２六歩 △８四歩 ▲１六歩 △９四歩 ▲２七飛 △９二香 ▲１八香\n" +
# >>   "まで9手で先手の勝ち\n",
# >>  :memberships=>
# >>   [{:id=>1,
# >>     :preset_key=>"平手",
# >>     :location_key=>"black",
# >>     :standby_at=>Sun, 27 May 2018 19:58:51 JST +09:00,
# >>     :fighting_at=>nil,
# >>     :time_up_at=>nil,
# >>     :user=>
# >>      {:id=>1,
# >>       :name=>"名無しの棋士1号",
# >>       :avatar_url=>
# >>        "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBEZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--8c3f3722c03a8b111db3ede72db9bc075d026871/51587037_p15_master1200.jpg"}},
# >>    {:id=>2,
# >>     :preset_key=>"平手",
# >>     :location_key=>"white",
# >>     :standby_at=>Sun, 27 May 2018 19:58:51 JST +09:00,
# >>     :fighting_at=>nil,
# >>     :time_up_at=>nil,
# >>     :user=>
# >>      {:id=>1,
# >>       :name=>"名無しの棋士1号",
# >>       :avatar_url=>
# >>        "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBEZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--8c3f3722c03a8b111db3ede72db9bc075d026871/51587037_p15_master1200.jpg"}}]}
