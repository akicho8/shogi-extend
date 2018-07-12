require File.expand_path('../../../config/environment', __FILE__) if $0 == __FILE__

module Fanta
  class BattleShowSerializer < ApplicationSerializer
    attributes :name, :show_path
    attributes :begin_at, :end_at
    attributes :battle_request_at, :auto_matched_at
    attributes :clock_counts, :countdown_flags
    attributes  :last_action_key, :win_location_key

    attributes *[
      :black_preset_key,
      :white_preset_key,
      :lifetime_key,
      :team_key,

      :full_sfen,
      :turn_max,

      :memberships_count,
      :watch_ships_count,

      :handicap,

      :human_kifu_text,           # これは重い
      :chat_window_size,
    ]

    has_many :memberships
    has_many :chat_messages
    has_many :watch_ships
  end

  if $0 == __FILE__
    pp ams_sr(Battle.last, serializer: BattleShowSerializer, include: {memberships: :user, chat_messages: :user, watch_ships: nil})
  end
end
# >> I, [2018-06-12T20:36:01.376431 #38956]  INFO -- : Rendered BattleShowSerializer with ActiveModelSerializers::Adapter::Attributes (1952.99ms)
# >> {:id=>53,
# >>  :name=>"#53",
# >>  :show_path=>"/online/battles/53",
# >>  :begin_at=>Tue, 12 Jun 2018 20:22:30 JST +09:00,
# >>  :end_at=>nil,
# >>  :battle_request_at=>nil,
# >>  :auto_matched_at=>Tue, 12 Jun 2018 20:22:26 JST +09:00,
# >>  :clock_counts=>{:black=>[], :white=>[]},
# >>  :countdown_flags=>{:black=>false, :white=>false},
# >>  :last_action_key=>nil,
# >>  :win_location_key=>nil,
# >>  :black_preset_key=>"平手",
# >>  :white_preset_key=>"平手",
# >>  :lifetime_key=>"lifetime_m5",
# >>  :team_key=>"team_p1vs1",
# >>  :full_sfen=>
# >>   "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1",
# >>  :turn_max=>0,
# >>  :current_users_count=>2,
# >>  :watch_ships_count=>0,
# >>  :handicap=>false,
# >>  :human_kifu_text=>
# >>   "開始日時：2018/06/12 20:22:30\n" +
# >>   "場所：http://localhost:3000/online/battles/53\n" +
# >>   "先手：名無しの棋士12号\n" +
# >>   "後手：名無しの棋士11号\n" +
# >>   "手合割：平手\n" +
# >>   "\n" +
# >>   "まで0手で後手の勝ち\n",
# >>  :chat_window_size=>10,
# >>  :memberships=>
# >>   [{:id=>205,
# >>     :location_key=>"black",
# >>     :preset_key=>"平手",
# >>     :standby_at=>Tue, 12 Jun 2018 20:22:28 JST +09:00,
# >>     :fighting_at=>Tue, 12 Jun 2018 20:25:31 JST +09:00,
# >>     :time_up_at=>nil,
# >>     :user=>
# >>      {:id=>12,
# >>       :name=>"名無しの棋士12号",
# >>       :show_path=>"/online/users/12",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0012_fallback_header_avatar_image-178e6778871d93f2ecc903e0fa22b878c89c0deaff8c2ea5fae7478d3e7210ff.png"}},
# >>    {:id=>206,
# >>     :location_key=>"white",
# >>     :preset_key=>"平手",
# >>     :standby_at=>Tue, 12 Jun 2018 20:22:30 JST +09:00,
# >>     :fighting_at=>Tue, 12 Jun 2018 20:34:46 JST +09:00,
# >>     :time_up_at=>nil,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}}],
# >>  :chat_messages=>
# >>   [{:id=>3,
# >>     :message=>"<span class=\"has-text-info\">入室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:22:28 JST +09:00,
# >>     :user=>
# >>      {:id=>12,
# >>       :name=>"名無しの棋士12号",
# >>       :show_path=>"/online/users/12",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0012_fallback_header_avatar_image-178e6778871d93f2ecc903e0fa22b878c89c0deaff8c2ea5fae7478d3e7210ff.png"}},
# >>    {:id=>4,
# >>     :message=>"<span class=\"has-text-info\">入室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:22:29 JST +09:00,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}},
# >>    {:id=>5,
# >>     :message=>"<span class=\"has-text-info\">退室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:24:17 JST +09:00,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}},
# >>    {:id=>6,
# >>     :message=>"<span class=\"has-text-info\">入室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:24:19 JST +09:00,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}},
# >>    {:id=>7,
# >>     :message=>"<span class=\"has-text-info\">退室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:24:52 JST +09:00,
# >>     :user=>
# >>      {:id=>12,
# >>       :name=>"名無しの棋士12号",
# >>       :show_path=>"/online/users/12",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0012_fallback_header_avatar_image-178e6778871d93f2ecc903e0fa22b878c89c0deaff8c2ea5fae7478d3e7210ff.png"}},
# >>    {:id=>8,
# >>     :message=>"<span class=\"has-text-info\">退室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:24:52 JST +09:00,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}},
# >>    {:id=>9,
# >>     :message=>"<span class=\"has-text-info\">入室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:25:05 JST +09:00,
# >>     :user=>
# >>      {:id=>12,
# >>       :name=>"名無しの棋士12号",
# >>       :show_path=>"/online/users/12",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0012_fallback_header_avatar_image-178e6778871d93f2ecc903e0fa22b878c89c0deaff8c2ea5fae7478d3e7210ff.png"}},
# >>    {:id=>10,
# >>     :message=>"<span class=\"has-text-info\">入室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:25:07 JST +09:00,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}},
# >>    {:id=>11,
# >>     :message=>"<span class=\"has-text-info\">退室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:25:09 JST +09:00,
# >>     :user=>
# >>      {:id=>12,
# >>       :name=>"名無しの棋士12号",
# >>       :show_path=>"/online/users/12",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0012_fallback_header_avatar_image-178e6778871d93f2ecc903e0fa22b878c89c0deaff8c2ea5fae7478d3e7210ff.png"}},
# >>    {:id=>12,
# >>     :message=>"<span class=\"has-text-info\">退室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:25:09 JST +09:00,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}},
# >>    {:id=>13,
# >>     :message=>"<span class=\"has-text-info\">入室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:25:10 JST +09:00,
# >>     :user=>
# >>      {:id=>12,
# >>       :name=>"名無しの棋士12号",
# >>       :show_path=>"/online/users/12",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0012_fallback_header_avatar_image-178e6778871d93f2ecc903e0fa22b878c89c0deaff8c2ea5fae7478d3e7210ff.png"}},
# >>    {:id=>14,
# >>     :message=>"<span class=\"has-text-info\">入室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:25:12 JST +09:00,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}},
# >>    {:id=>15,
# >>     :message=>"<span class=\"has-text-info\">退室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:25:13 JST +09:00,
# >>     :user=>
# >>      {:id=>12,
# >>       :name=>"名無しの棋士12号",
# >>       :show_path=>"/online/users/12",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0012_fallback_header_avatar_image-178e6778871d93f2ecc903e0fa22b878c89c0deaff8c2ea5fae7478d3e7210ff.png"}},
# >>    {:id=>16,
# >>     :message=>"<span class=\"has-text-info\">退室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:25:13 JST +09:00,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}},
# >>    {:id=>17,
# >>     :message=>"<span class=\"has-text-info\">入室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:25:14 JST +09:00,
# >>     :user=>
# >>      {:id=>12,
# >>       :name=>"名無しの棋士12号",
# >>       :show_path=>"/online/users/12",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0012_fallback_header_avatar_image-178e6778871d93f2ecc903e0fa22b878c89c0deaff8c2ea5fae7478d3e7210ff.png"}},
# >>    {:id=>18,
# >>     :message=>"<span class=\"has-text-info\">入室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:25:16 JST +09:00,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}},
# >>    {:id=>19,
# >>     :message=>"<span class=\"has-text-info\">退室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:25:18 JST +09:00,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}},
# >>    {:id=>20,
# >>     :message=>"<span class=\"has-text-info\">退室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:25:18 JST +09:00,
# >>     :user=>
# >>      {:id=>12,
# >>       :name=>"名無しの棋士12号",
# >>       :show_path=>"/online/users/12",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0012_fallback_header_avatar_image-178e6778871d93f2ecc903e0fa22b878c89c0deaff8c2ea5fae7478d3e7210ff.png"}},
# >>    {:id=>21,
# >>     :message=>"<span class=\"has-text-info\">入室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:25:19 JST +09:00,
# >>     :user=>
# >>      {:id=>12,
# >>       :name=>"名無しの棋士12号",
# >>       :show_path=>"/online/users/12",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0012_fallback_header_avatar_image-178e6778871d93f2ecc903e0fa22b878c89c0deaff8c2ea5fae7478d3e7210ff.png"}},
# >>    {:id=>22,
# >>     :message=>"<span class=\"has-text-info\">入室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:25:20 JST +09:00,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}},
# >>    {:id=>23,
# >>     :message=>"<span class=\"has-text-info\">退室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:25:25 JST +09:00,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}},
# >>    {:id=>24,
# >>     :message=>"<span class=\"has-text-info\">退室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:25:25 JST +09:00,
# >>     :user=>
# >>      {:id=>12,
# >>       :name=>"名無しの棋士12号",
# >>       :show_path=>"/online/users/12",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0012_fallback_header_avatar_image-178e6778871d93f2ecc903e0fa22b878c89c0deaff8c2ea5fae7478d3e7210ff.png"}},
# >>    {:id=>25,
# >>     :message=>"<span class=\"has-text-info\">入室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:25:25 JST +09:00,
# >>     :user=>
# >>      {:id=>12,
# >>       :name=>"名無しの棋士12号",
# >>       :show_path=>"/online/users/12",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0012_fallback_header_avatar_image-178e6778871d93f2ecc903e0fa22b878c89c0deaff8c2ea5fae7478d3e7210ff.png"}},
# >>    {:id=>26,
# >>     :message=>"<span class=\"has-text-info\">入室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:25:27 JST +09:00,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}},
# >>    {:id=>27,
# >>     :message=>"<span class=\"has-text-info\">退室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:25:31 JST +09:00,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}},
# >>    {:id=>28,
# >>     :message=>"<span class=\"has-text-info\">退室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:25:31 JST +09:00,
# >>     :user=>
# >>      {:id=>12,
# >>       :name=>"名無しの棋士12号",
# >>       :show_path=>"/online/users/12",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0012_fallback_header_avatar_image-178e6778871d93f2ecc903e0fa22b878c89c0deaff8c2ea5fae7478d3e7210ff.png"}},
# >>    {:id=>29,
# >>     :message=>"<span class=\"has-text-info\">入室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:25:31 JST +09:00,
# >>     :user=>
# >>      {:id=>12,
# >>       :name=>"名無しの棋士12号",
# >>       :show_path=>"/online/users/12",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0012_fallback_header_avatar_image-178e6778871d93f2ecc903e0fa22b878c89c0deaff8c2ea5fae7478d3e7210ff.png"}},
# >>    {:id=>30,
# >>     :message=>"<span class=\"has-text-info\">入室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:25:33 JST +09:00,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}},
# >>    {:id=>31,
# >>     :message=>"<span class=\"has-text-info\">入室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:27:14 JST +09:00,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}},
# >>    {:id=>32,
# >>     :message=>"<span class=\"has-text-info\">退室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:27:36 JST +09:00,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}},
# >>    {:id=>33,
# >>     :message=>"<span class=\"has-text-info\">入室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:27:37 JST +09:00,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}},
# >>    {:id=>34,
# >>     :message=>"<span class=\"has-text-info\">退室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:28:02 JST +09:00,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}},
# >>    {:id=>35,
# >>     :message=>"<span class=\"has-text-info\">入室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:28:03 JST +09:00,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}},
# >>    {:id=>36,
# >>     :message=>"<span class=\"has-text-info\">退室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:28:14 JST +09:00,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}},
# >>    {:id=>37,
# >>     :message=>"<span class=\"has-text-info\">入室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:28:16 JST +09:00,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}},
# >>    {:id=>38,
# >>     :message=>"<span class=\"has-text-info\">退室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:28:18 JST +09:00,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}},
# >>    {:id=>39,
# >>     :message=>"<span class=\"has-text-info\">入室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:28:20 JST +09:00,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}},
# >>    {:id=>40,
# >>     :message=>"<span class=\"has-text-info\">入室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:29:22 JST +09:00,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}},
# >>    {:id=>41,
# >>     :message=>"<span class=\"has-text-info\">退室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:29:28 JST +09:00,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}},
# >>    {:id=>42,
# >>     :message=>"<span class=\"has-text-info\">入室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:29:33 JST +09:00,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}},
# >>    {:id=>43,
# >>     :message=>"<span class=\"has-text-info\">退室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:29:37 JST +09:00,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}},
# >>    {:id=>44,
# >>     :message=>"<span class=\"has-text-info\">入室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:29:38 JST +09:00,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}},
# >>    {:id=>45,
# >>     :message=>"<span class=\"has-text-info\">入室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:33:09 JST +09:00,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}},
# >>    {:id=>46,
# >>     :message=>"<span class=\"has-text-info\">退室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:33:10 JST +09:00,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}},
# >>    {:id=>47,
# >>     :message=>"<span class=\"has-text-info\">入室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:33:12 JST +09:00,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}},
# >>    {:id=>48,
# >>     :message=>"<span class=\"has-text-info\">入室しました</span>",
# >>     :created_at=>Tue, 12 Jun 2018 20:34:46 JST +09:00,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}}],
# >>  :watch_users=>[]}
# >> I, [2018-06-12T20:36:01.406768 #38956]  INFO -- : Rendered BattleShowSerializer with ActiveModelSerializers::Adapter::Attributes (14.62ms)
# >> {:id=>53,
# >>  :name=>"#53",
# >>  :show_path=>"/online/battles/53",
# >>  :begin_at=>Tue, 12 Jun 2018 20:22:30 JST +09:00,
# >>  :end_at=>nil,
# >>  :battle_request_at=>nil,
# >>  :auto_matched_at=>Tue, 12 Jun 2018 20:22:26 JST +09:00,
# >>  :clock_counts=>{:black=>[], :white=>[]},
# >>  :countdown_flags=>{:black=>false, :white=>false},
# >>  :last_action_key=>nil,
# >>  :win_location_key=>nil,
# >>  :black_preset_key=>"平手",
# >>  :white_preset_key=>"平手",
# >>  :lifetime_key=>"lifetime_m5",
# >>  :team_key=>"team_p1vs1",
# >>  :full_sfen=>
# >>   "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1",
# >>  :turn_max=>0,
# >>  :current_users_count=>2,
# >>  :watch_ships_count=>0,
# >>  :handicap=>false,
# >>  :human_kifu_text=>
# >>   "開始日時：2018/06/12 20:22:30\n" +
# >>   "場所：http://localhost:3000/online/battles/53\n" +
# >>   "先手：名無しの棋士12号\n" +
# >>   "後手：名無しの棋士11号\n" +
# >>   "手合割：平手\n" +
# >>   "\n" +
# >>   "まで0手で後手の勝ち\n",
# >>  :chat_window_size=>10,
# >>  :memberships=>
# >>   [{:id=>205,
# >>     :location_key=>"black",
# >>     :preset_key=>"平手",
# >>     :standby_at=>Tue, 12 Jun 2018 20:22:28 JST +09:00,
# >>     :fighting_at=>Tue, 12 Jun 2018 20:25:31 JST +09:00,
# >>     :time_up_at=>nil,
# >>     :user=>
# >>      {:id=>12,
# >>       :name=>"名無しの棋士12号",
# >>       :show_path=>"/online/users/12",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0012_fallback_header_avatar_image-178e6778871d93f2ecc903e0fa22b878c89c0deaff8c2ea5fae7478d3e7210ff.png"}},
# >>    {:id=>206,
# >>     :location_key=>"white",
# >>     :preset_key=>"平手",
# >>     :standby_at=>Tue, 12 Jun 2018 20:22:30 JST +09:00,
# >>     :fighting_at=>Tue, 12 Jun 2018 20:34:46 JST +09:00,
# >>     :time_up_at=>nil,
# >>     :user=>
# >>      {:id=>11,
# >>       :name=>"名無しの棋士11号",
# >>       :show_path=>"/online/users/11",
# >>       :avatar_url=>
# >>        "/assets/fallback_avatars/0011_fallback_header_avatar_image-28288cf16f08dc2cfc1a1fb81818a3fd0b2bda49e0f1884d38cbdfe2328f6f0b.png"}}]}
