#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

pp ActiveModelSerializers::SerializableResource.new(ChatUser.first).as_json
pp ActiveModelSerializers::SerializableResource.new(LobbyChatMessage.first).as_json
pp ActiveModelSerializers::SerializableResource.new(ChatRoom.first, include: {chat_memberships: :chat_user}).as_json
# >> {:id=>1,
# >>  :name=>"野良1号",
# >>  :current_chat_room_id=>nil,
# >>  :online_at=>nil,
# >>  :fighting_now_at=>nil,
# >>  :matching_at=>nil,
# >>  :lifetime_key=>"lifetime5_min",
# >>  :ps_preset_key=>"平手",
# >>  :po_preset_key=>"平手",
# >>  :avatar_url=>
# >>   "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--bda60366d3f3573c24c096e0d889993b7ca06772/0270_kemono_friends.png"}
# >> {:id=>1,
# >>  :message=>"aa",
# >>  :created_at=>Tue, 29 May 2018 20:52:47 JST +09:00,
# >>  :chat_user=>
# >>   {:id=>1,
# >>    :name=>"野良1号",
# >>    :avatar_url=>
# >>     "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--bda60366d3f3573c24c096e0d889993b7ca06772/0270_kemono_friends.png"}}
# >> {:id=>1,
# >>  :room_owner_id=>1,
# >>  :black_preset_key=>"平手",
# >>  :white_preset_key=>"平手",
# >>  :lifetime_key=>"lifetime5_min",
# >>  :name=>"野良1号の対戦部屋 #1",
# >>  :kifu_body_sfen=>
# >>   "position startpos moves 7g7f 5c5d 2g2f 8c8d 1g1f 9c9d 2h2g 9a9b 1i1h",
# >>  :clock_counts=>{:black=>[3, 8, 6, 62, 3], :white=>[2, 43, 4, 20]},
# >>  :turn_max=>9,
# >>  :battle_request_at=>Sun, 27 May 2018 19:58:48 JST +09:00,
# >>  :auto_matched_at=>nil,
# >>  :begin_at=>Sun, 27 May 2018 19:58:51 JST +09:00,
# >>  :end_at=>Sun, 27 May 2018 20:01:37 JST +09:00,
# >>  :last_action_key=>"ILLEGAL_MOVE",
# >>  :win_location_key=>"black",
# >>  :current_chat_users_count=>-2,
# >>  :watch_memberships_count=>0,
# >>  :show_path=>"/online/battles/1",
# >>  :handicap=>false,
# >>  :chat_memberships=>
# >>   [{:id=>1,
# >>     :preset_key=>"平手",
# >>     :location_key=>"black",
# >>     :standby_at=>Sun, 27 May 2018 19:58:51 JST +09:00,
# >>     :fighting_now_at=>nil,
# >>     :time_up_trigger_at=>nil,
# >>     :chat_user=>
# >>      {:id=>1,
# >>       :name=>"野良1号",
# >>       :avatar_url=>
# >>        "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--bda60366d3f3573c24c096e0d889993b7ca06772/0270_kemono_friends.png"}},
# >>    {:id=>2,
# >>     :preset_key=>"平手",
# >>     :location_key=>"white",
# >>     :standby_at=>Sun, 27 May 2018 19:58:51 JST +09:00,
# >>     :fighting_now_at=>nil,
# >>     :time_up_trigger_at=>nil,
# >>     :chat_user=>
# >>      {:id=>1,
# >>       :name=>"野良1号",
# >>       :avatar_url=>
# >>        "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--bda60366d3f3573c24c096e0d889993b7ca06772/0270_kemono_friends.png"}}]}
