Rails.application.routes.draw do
  namespace :resource_ns1, path: "" do
    resources :battle_rooms, path: "online/battles"
    resources :users, path: "online/users"
  end

  root "resource_ns1/battle_rooms#index"

  ################################################################################ 2ch棋譜検索

  namespace :resource_ns1, path: "" do
    resources :general_battle_records, path: "sr", only: [:index, :show] do
      resources :tag_cloud, :only => :index, :module => :general_battle_records
    end

    get "s/:query", to: "general_battle_records#index", as: :general_search
    get "s",        to: "general_battle_records#index"
    get "s-cloud",  to: "general_battle_records/tag_cloud#index", as: :general_cloud
  end

  resolve "GeneralBattleUser" do |general_battle_user, options|
    resource_ns1_general_search_path(query: general_battle_user.to_param)
  end

  ################################################################################ 将棋ウォーズ棋譜検索

  namespace :resource_ns1, path: "" do
    resources :swars_battle_records, path: "wr", only: [:index, :show] do
      resources :tag_cloud, :only => :index, :module => :swars_battle_records
    end

    get "w/:query", to: "swars_battle_records#index", as: :swars_search
    get "w",        to: "swars_battle_records#index"
    get "w-cloud",  to: "swars_battle_records/tag_cloud#index", as: :swars_cloud
  end

  resolve "SwarsBattleUser" do |swars_battle_user, options|
    resource_ns1_swars_search_path(query: swars_battle_user.to_param)
  end

  ################################################################################ 棋譜変換

  namespace :resource_ns1, path: "" do
    resources :free_battle_records, path: "x"
  end

  resolve "FreeBattleRecord" do |free_battle_record, options|
    [:resource_ns1, free_battle_record, options]
  end

  ################################################################################ 戦法トリガー辞典

  resources :tactic_articles, path: "tactics", only: [:index, :show]

  get "tactics-tree",   to: "tactic_articles#index", defaults: {mode: "tree"}, as: :tree
  get "tactics-fortune", to: "tactic_articles#index", defaults: {mode: "fortune"}, as: :fortune

  ################################################################################ 符号入力ゲーム

  get "xy", to: "xy_game#show"

  ################################################################################ 局面編集

  get "position-editor", to: "position_editor#show", as: :position_editor

  ################################################################################ CPU対戦

  resource :cpu_versus, path: "cpu/versus", only: [:show, :create]
  get "cpu-versus", to: "cpu_versus#show"

  ################################################################################ 外部リンク

  direct :swars_real_battle do |swars_battle_record, **options|
    options = {
      locale: "ja",
    }.merge(options)
    "http://kif-pona.heroz.jp/games/#{swars_battle_record.battle_key}?#{options.to_query}"
  end

  direct :mountain_upload do
    "http://shogi-s.com/upload-text"
  end

  direct :piyo_shogi_app do |url|
    "piyoshogi://?url=#{url}"
  end

  direct :google_search do |query|
    "https://www.google.co.jp/search?source=ig&hl=ja&lr=lang_ja&q=#{query}"
  end

  direct :google_maps do |query|
    "https://www.google.co.jp/maps/search/#{query}"
  end

  direct :youtube_search do |query|
    "https://www.youtube.com/results?search_query=#{query}&search=Search"
  end
end
