require File.expand_path('../../../../config/environment', __FILE__) if $0 == __FILE__

module Colosseum
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
      :chat_display_lines_limit,
    ]

    has_many :memberships
    has_many :chat_messages
    has_many :watch_ships
  end

  if $0 == __FILE__
    pp ams_sr(Battle.last, serializer: BattleShowSerializer, include: {memberships: :user, chat_messages: :user, watch_ships: nil})
  end
end
# >> {:id=>50,
# >>  :name=>"#50",
# >>  :show_path=>"/colosseum/battles/50",
# >>  :begin_at=>nil,
# >>  :end_at=>nil,
# >>  :battle_request_at=>nil,
# >>  :auto_matched_at=>nil,
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
# >>  :memberships_count=>4,
# >>  :watch_ships_count=>0,
# >>  :handicap=>false,
# >>  :human_kifu_text=>
# >>   "場所：http://localhost:3000/colosseum/battles/50\n" +
# >>   "先手：あきれるほど弱いCPU・運営\n" +
# >>   "後手：ルール覚えたてのCPU・ありえないほど弱いCPU\n" +
# >>   "手合割：平手\n" +
# >>   "\n" +
# >>   "まで0手で後手の勝ち\n",
# >>  :chat_display_lines_limit=>25,
# >>  :memberships=>
# >>   [{:id=>197,
# >>     :location_key=>"black",
# >>     :preset_key=>"平手",
# >>     :standby_at=>nil,
# >>     :fighting_at=>nil,
# >>     :time_up_at=>nil,
# >>     :user=>
# >>      {:id=>3,
# >>       :name=>"あきれるほど弱いCPU",
# >>       :show_path=>"/colosseum/users/3",
# >>       :avatar_path=>
# >>        "/assets/robot/0120_robot-da4aa855dd2b8d97caf50f6c9a2155fc19e8fea5252c86a38f23c864a743f2b1.png",
# >>       :race_key=>"robot",
# >>       :win_count=>0,
# >>       :lose_count=>0,
# >>       :win_ratio=>0.0}},
# >>    {:id=>198,
# >>     :location_key=>"white",
# >>     :preset_key=>"平手",
# >>     :standby_at=>nil,
# >>     :fighting_at=>nil,
# >>     :time_up_at=>nil,
# >>     :user=>
# >>      {:id=>2,
# >>       :name=>"ルール覚えたてのCPU",
# >>       :show_path=>"/colosseum/users/2",
# >>       :avatar_path=>
# >>        "/assets/robot/0110_robot-e704feafb4d5b9c5bdc19e6e70d310f7bccafa00f22cdb9e32f7c8cdc321b71a.png",
# >>       :race_key=>"robot",
# >>       :win_count=>0,
# >>       :lose_count=>0,
# >>       :win_ratio=>0.0}},
# >>    {:id=>199,
# >>     :location_key=>"black",
# >>     :preset_key=>"平手",
# >>     :standby_at=>nil,
# >>     :fighting_at=>nil,
# >>     :time_up_at=>nil,
# >>     :user=>
# >>      {:id=>1,
# >>       :name=>"運営",
# >>       :show_path=>"/colosseum/users/1",
# >>       :avatar_path=>
# >>        "/assets/human/0013_fallback_avatar_icon-7ccc24e76f53875ea71137f6079ae8ad0657b15e80aeed6852501da430e757df.png",
# >>       :race_key=>"human",
# >>       :win_count=>0,
# >>       :lose_count=>0,
# >>       :win_ratio=>0.0}},
# >>    {:id=>200,
# >>     :location_key=>"white",
# >>     :preset_key=>"平手",
# >>     :standby_at=>nil,
# >>     :fighting_at=>nil,
# >>     :time_up_at=>nil,
# >>     :user=>
# >>      {:id=>4,
# >>       :name=>"ありえないほど弱いCPU",
# >>       :show_path=>"/colosseum/users/4",
# >>       :avatar_path=>
# >>        "/assets/robot/0100_robot-66c73ea6ee9d1d87bad3f3b22739b74cbe9bdba17b06e9f65a8f7f63b6fb2467.png",
# >>       :race_key=>"robot",
# >>       :win_count=>0,
# >>       :lose_count=>0,
# >>       :win_ratio=>0.0}}],
# >>  :chat_messages=>[],
# >>  :watch_ships=>[]}
