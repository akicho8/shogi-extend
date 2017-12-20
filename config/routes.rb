Rails.application.routes.draw do
  namespace :resource_ns1, path: "" do
    # 棋譜変換
    resources :free_battle_records, path: "x"

    # 検索系
    resources :battle_users
    resources :battle_records, path: "r"
    resources :battle_ships
  end

  ################################################################################ 棋譜変換

  resolve "FreeBattleRecord" do |free_battle_record, options|
    [:resource_ns1, free_battle_record, options]
  end

  ################################################################################ 検索

  get "s/:query", to: "swars_tops#show", as: :query_search
  get "s", to: "swars_tops#show"
  get "cloud", to: "swars_tops#tag_cloud"
  get "xy", to: "swars_tops#coordinates_sign_enter_game"

  get "swars_tops/show"
  root "swars_tops#show"

  resolve "BattleUser" do |battle_user, options|
    query_search_path(query: battle_user.to_param)
  end

  ################################################################################ 辞典

  resources :formation_articles, path: "tactics"
  get "tactics-tree", to: "formation_articles#index", defaults: {tree: "true"}, as: :tree

  ################################################################################ 今日の戦法占い

  resource :random_articles, path: "random"

  ################################################################################ その他

  get "tops/show"

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
