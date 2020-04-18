require File.expand_path('../../../../config/environment', __FILE__) if $0 == __FILE__

module Colosseum
  class LobbySerializer < ApplicationSerializer
    def id
    end

    has_many :battles, serializer: BattleEachSerializer do
      Colosseum::Battle.st_battle_now.latest_list
    end

    has_many :lobby_messages do
      Colosseum::LobbyMessage.latest_list.reverse
    end

    has_many :online_users, serializer: OnlineUserSerializer do
      Colosseum::User.joined_only.order(joined_at: :desc)
    end
  end

  if $0 == __FILE__
    pp ams_sr({}, root: "root_name_need_for_ver0_10_10", serializer: LobbySerializer, include: {battles: {memberships: :user}, lobby_messages: :user, online_users: {active_battles: nil}})
  end
end
# >> {:id=>nil,
# >>  :battles=>[],
# >>  :lobby_messages=>
# >>   [{:id=>128,
# >>     :message=>"符号の鬼のランキングを名前でユニークにする機能をつけました",
# >>     :msg_options=>{:msg_options=>{}},
# >>     :created_at=>Sun, 15 Sep 2019 18:26:57 JST +09:00,
# >>     :user=>
# >>      {:id=>8,
# >>       :name=>"きなこもち",
# >>       :show_path=>"/colosseum/users/8",
# >>       :avatar_path=>
# >>        "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--0f9af388bf27f702de208f3e186632294ee9b7c2/sgkinakomochi.png",
# >>       :race_key=>"human",
# >>       :win_count=>12,
# >>       :lose_count=>11,
# >>       :win_ratio=>0.522,
# >>       :joined_at=>nil}},
# >>    {:id=>129,
# >>     :message=>"ネット対戦するにはまずロビーに入室してからにするようにしました",
# >>     :msg_options=>{:msg_options=>{}},
# >>     :created_at=>Sun, 15 Sep 2019 18:27:54 JST +09:00,
# >>     :user=>
# >>      {:id=>8,
# >>       :name=>"きなこもち",
# >>       :show_path=>"/colosseum/users/8",
# >>       :avatar_path=>
# >>        "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--0f9af388bf27f702de208f3e186632294ee9b7c2/sgkinakomochi.png",
# >>       :race_key=>"human",
# >>       :win_count=>12,
# >>       :lose_count=>11,
# >>       :win_ratio=>0.522,
# >>       :joined_at=>nil}},
# >>    {:id=>130,
# >>     :message=>
# >>      "ストップウォッチのURLに永続化のためハッシュを付与しないようにしました。以前は、ストップウォッチで現在のURLをブックマークすると、その時点の状態を保持した状態でブックマークしていて、そうすると前の続きから再開する意図とは異なった挙動になってしまうため、ハッシュを取り除き、常に前回の続きから行なえるようにしました。(永続化データはブラウザにのみ保存しています)",
# >>     :msg_options=>{:msg_options=>{}},
# >>     :created_at=>Tue, 17 Sep 2019 10:46:37 JST +09:00,
# >>     :user=>
# >>      {:id=>8,
# >>       :name=>"きなこもち",
# >>       :show_path=>"/colosseum/users/8",
# >>       :avatar_path=>
# >>        "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--0f9af388bf27f702de208f3e186632294ee9b7c2/sgkinakomochi.png",
# >>       :race_key=>"human",
# >>       :win_count=>12,
# >>       :lose_count=>11,
# >>       :win_ratio=>0.522,
# >>       :joined_at=>nil}},
# >>    {:id=>131,
# >>     :message=>"棋譜に特殊文字が含まれている場合にエラーになるのを修正しました",
# >>     :msg_options=>{:msg_options=>{}},
# >>     :created_at=>Tue, 17 Sep 2019 14:16:53 JST +09:00,
# >>     :user=>
# >>      {:id=>8,
# >>       :name=>"きなこもち",
# >>       :show_path=>"/colosseum/users/8",
# >>       :avatar_path=>
# >>        "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--0f9af388bf27f702de208f3e186632294ee9b7c2/sgkinakomochi.png",
# >>       :race_key=>"human",
# >>       :win_count=>12,
# >>       :lose_count=>11,
# >>       :win_ratio=>0.522,
# >>       :joined_at=>nil}},
# >>    {:id=>132,
# >>     :message=>"絵文字の入力に対応しました🍣",
# >>     :msg_options=>{:msg_options=>{}},
# >>     :created_at=>Tue, 17 Sep 2019 14:18:35 JST +09:00,
# >>     :user=>
# >>      {:id=>8,
# >>       :name=>"きなこもち",
# >>       :show_path=>"/colosseum/users/8",
# >>       :avatar_path=>
# >>        "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--0f9af388bf27f702de208f3e186632294ee9b7c2/sgkinakomochi.png",
# >>       :race_key=>"human",
# >>       :win_count=>12,
# >>       :lose_count=>11,
# >>       :win_ratio=>0.522,
# >>       :joined_at=>nil}},
# >>    {:id=>133,
# >>     :message=>
# >>      "棋譜投稿時の棋譜にコメントとして「解析」や「最善手」などのデータが大量に含まれている場合、容量の問題でエラーになるので、「**」ではじまるコメントのみ自動消去するようにしました",
# >>     :msg_options=>{:msg_options=>{}},
# >>     :created_at=>Tue, 17 Sep 2019 15:06:14 JST +09:00,
# >>     :user=>
# >>      {:id=>8,
# >>       :name=>"きなこもち",
# >>       :show_path=>"/colosseum/users/8",
# >>       :avatar_path=>
# >>        "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--0f9af388bf27f702de208f3e186632294ee9b7c2/sgkinakomochi.png",
# >>       :race_key=>"human",
# >>       :win_count=>12,
# >>       :lose_count=>11,
# >>       :win_ratio=>0.522,
# >>       :joined_at=>nil}},
# >>    {:id=>134,
# >>     :message=>"ログインしたときの名前に絵文字が含まれていてもそのまま表示できるようにしました",
# >>     :msg_options=>{:msg_options=>{}},
# >>     :created_at=>Tue, 17 Sep 2019 15:21:46 JST +09:00,
# >>     :user=>
# >>      {:id=>8,
# >>       :name=>"きなこもち",
# >>       :show_path=>"/colosseum/users/8",
# >>       :avatar_path=>
# >>        "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--0f9af388bf27f702de208f3e186632294ee9b7c2/sgkinakomochi.png",
# >>       :race_key=>"human",
# >>       :win_count=>12,
# >>       :lose_count=>11,
# >>       :win_ratio=>0.522,
# >>       :joined_at=>nil}},
# >>    {:id=>135,
# >>     :message=>"符号の鬼のマラソンモードはめんどくさくてやらなくなったので廃止",
# >>     :msg_options=>{:msg_options=>{}},
# >>     :created_at=>Thu, 19 Sep 2019 11:02:02 JST +09:00,
# >>     :user=>
# >>      {:id=>8,
# >>       :name=>"きなこもち",
# >>       :show_path=>"/colosseum/users/8",
# >>       :avatar_path=>
# >>        "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--0f9af388bf27f702de208f3e186632294ee9b7c2/sgkinakomochi.png",
# >>       :race_key=>"human",
# >>       :win_count=>12,
# >>       :lose_count=>11,
# >>       :win_ratio=>0.522,
# >>       :joined_at=>nil}},
# >>    {:id=>136,
# >>     :message=>"符号入力ゲーの1・10・30問はあんまやらないので廃止",
# >>     :msg_options=>{:msg_options=>{}},
# >>     :created_at=>Mon, 23 Sep 2019 19:26:00 JST +09:00,
# >>     :user=>
# >>      {:id=>8,
# >>       :name=>"きなこもち",
# >>       :show_path=>"/colosseum/users/8",
# >>       :avatar_path=>
# >>        "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--0f9af388bf27f702de208f3e186632294ee9b7c2/sgkinakomochi.png",
# >>       :race_key=>"human",
# >>       :win_count=>12,
# >>       :lose_count=>11,
# >>       :win_ratio=>0.522,
# >>       :joined_at=>nil}},
# >>    {:id=>137,
# >>     :message=>"かわりに後手目線の100問と、符号を見てセルをタップするルールを追加",
# >>     :msg_options=>{:msg_options=>{}},
# >>     :created_at=>Mon, 23 Sep 2019 19:27:00 JST +09:00,
# >>     :user=>
# >>      {:id=>8,
# >>       :name=>"きなこもち",
# >>       :show_path=>"/colosseum/users/8",
# >>       :avatar_path=>
# >>        "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--0f9af388bf27f702de208f3e186632294ee9b7c2/sgkinakomochi.png",
# >>       :race_key=>"human",
# >>       :win_count=>12,
# >>       :lose_count=>11,
# >>       :win_ratio=>0.522,
# >>       :joined_at=>nil}}],
# >>  :online_users=>
# >>   [{:id=>7,
# >>     :name=>"弱いCPU",
# >>     :show_path=>"/colosseum/users/7",
# >>     :avatar_path=>
# >>      "/assets/robot/0140_robot-31e558f84b967f63efd70bcfd54af2398ab701b0102470e503d349192dbb35da.png",
# >>     :race_key=>"robot",
# >>     :win_count=>5,
# >>     :lose_count=>12,
# >>     :win_ratio=>0.294,
# >>     :joined_at=>Fri, 13 Sep 2019 16:44:22 JST +09:00,
# >>     :fighting_at=>nil,
# >>     :matching_at=>nil,
# >>     :active_battles=>
# >>      [{:id=>159, :name=>"#159", :show_path=>"/colosseum/battles/159"}]},
# >>    {:id=>3,
# >>     :name=>"あきれるほど弱いCPU",
# >>     :show_path=>"/colosseum/users/3",
# >>     :avatar_path=>
# >>      "/assets/robot/0120_robot-da4aa855dd2b8d97caf50f6c9a2155fc19e8fea5252c86a38f23c864a743f2b1.png",
# >>     :race_key=>"robot",
# >>     :win_count=>6,
# >>     :lose_count=>13,
# >>     :win_ratio=>0.316,
# >>     :joined_at=>Fri, 13 Sep 2019 16:44:16 JST +09:00,
# >>     :fighting_at=>nil,
# >>     :matching_at=>nil,
# >>     :active_battles=>
# >>      [{:id=>130, :name=>"#130", :show_path=>"/colosseum/battles/130"}]},
# >>    {:id=>4,
# >>     :name=>"ありえないほど弱いCPU",
# >>     :show_path=>"/colosseum/users/4",
# >>     :avatar_path=>
# >>      "/assets/robot/0100_robot-66c73ea6ee9d1d87bad3f3b22739b74cbe9bdba17b06e9f65a8f7f63b6fb2467.png",
# >>     :race_key=>"robot",
# >>     :win_count=>13,
# >>     :lose_count=>17,
# >>     :win_ratio=>0.433,
# >>     :joined_at=>Fri, 13 Sep 2019 16:44:16 JST +09:00,
# >>     :fighting_at=>nil,
# >>     :matching_at=>nil,
# >>     :active_battles=>
# >>      [{:id=>116, :name=>"#116", :show_path=>"/colosseum/battles/116"}]},
# >>    {:id=>5,
# >>     :name=>"めちゃくちゃ弱いCPU",
# >>     :show_path=>"/colosseum/users/5",
# >>     :avatar_path=>
# >>      "/assets/robot/0150_robot-619f7c7c4831fffd861716e3c76fe47c8605b2a036522a89d2635078b20bc213.png",
# >>     :race_key=>"robot",
# >>     :win_count=>7,
# >>     :lose_count=>21,
# >>     :win_ratio=>0.25,
# >>     :joined_at=>Fri, 13 Sep 2019 16:44:16 JST +09:00,
# >>     :fighting_at=>nil,
# >>     :matching_at=>nil,
# >>     :active_battles=>
# >>      [{:id=>115, :name=>"#115", :show_path=>"/colosseum/battles/115"}]},
# >>    {:id=>6,
# >>     :name=>"かなり弱いCPU",
# >>     :show_path=>"/colosseum/users/6",
# >>     :avatar_path=>
# >>      "/assets/robot/0130_robot-fd50cb547420b0fd51a8f0c0e2c101d0ea25c5b93e47f66a3dd5e71c5ba51b62.png",
# >>     :race_key=>"robot",
# >>     :win_count=>1,
# >>     :lose_count=>3,
# >>     :win_ratio=>0.25,
# >>     :joined_at=>Fri, 13 Sep 2019 16:44:16 JST +09:00,
# >>     :fighting_at=>nil,
# >>     :matching_at=>nil,
# >>     :active_battles=>[]},
# >>    {:id=>2,
# >>     :name=>"ルール覚えたてのCPU",
# >>     :show_path=>"/colosseum/users/2",
# >>     :avatar_path=>
# >>      "/assets/robot/0110_robot-e704feafb4d5b9c5bdc19e6e70d310f7bccafa00f22cdb9e32f7c8cdc321b71a.png",
# >>     :race_key=>"robot",
# >>     :win_count=>5,
# >>     :lose_count=>22,
# >>     :win_ratio=>0.185,
# >>     :joined_at=>Fri, 13 Sep 2019 16:44:14 JST +09:00,
# >>     :fighting_at=>nil,
# >>     :matching_at=>nil,
# >>     :active_battles=>
# >>      [{:id=>108, :name=>"#108", :show_path=>"/colosseum/battles/108"},
# >>       {:id=>134, :name=>"#134", :show_path=>"/colosseum/battles/134"}]}]}
