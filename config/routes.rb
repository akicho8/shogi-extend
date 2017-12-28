Rails.application.routes.draw do
  root "swars_tops#show"

  ################################################################################ 2ch棋譜検索

  namespace :resource_ns1, path: "" do
    resources :battle2_users
    resources :battle2_records, path: "or"
    resources :battle2_ships
  end

  get "s/:query", to: "pro_wars_tops#show", as: :kifu_query_search
  get "s", to: "pro_wars_tops#show"

  get "pro_wars_tops/show"
  get "s-cloud", to: "pro_wars_tops#tag_cloud", as: :general_cloud

  resolve "Battle2User" do |battle2_user, options|
    kifu_query_search_path(query: battle2_user.to_param)
  end

  ################################################################################ 将棋ウォーズ棋譜検索

  namespace :resource_ns1, path: "" do
    resources :battle_users
    resources :battle_records, path: "wr"
    resources :battle_ships
  end

  get "w/:query", to: "swars_tops#show", as: :wars_query_search
  get "w", to: "swars_tops#show"
  get "w-cloud", to: "swars_tops#tag_cloud", as: :wars_cloud

  get "swars_tops/show"

  resolve "BattleUser" do |battle_user, options|
    wars_query_search_path(query: battle_user.to_param)
  end

  ################################################################################ 棋譜変換

  namespace :resource_ns1, path: "" do
    resources :free_battle_records, path: "x"
  end

  resolve "FreeBattleRecord" do |free_battle_record, options|
    [:resource_ns1, free_battle_record, options]
  end

  ################################################################################ 戦法トリガー辞典

  resources :formation_articles, path: "tactics"

  get "tactics-tree", to: "formation_articles#index", defaults: {tree: "true"}, as: :tree

  ################################################################################ 今日の戦法占い

  resource :random_articles, path: "random"

  ################################################################################ 符号入力ゲーム

  get "xy", to: "xy_game#show"

  ################################################################################ 外部リンク

  direct :swars_real_battle do |battle_record|
    "http://kif-pona.heroz.jp/games/#{battle_record.battle_key}?locale=ja"
  end

  direct :mountain_upload do
    "http://shogi-s.com/upload-text"
  end

  direct :piyo_shogi_app do |url|
    "piyoshogi://?url=#{url}"
  end
end
