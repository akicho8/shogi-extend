Rails.application.routes.draw do
  namespace :fanta, path: "" do
    resources :battles, path: "online/battles"
    resources :users, path: "online/users"
  end

  root "fanta/battles#index"

  ################################################################################ 2ch棋譜検索

  namespace :general, path: "" do
    resources :battles, path: "sr", only: [:index, :show] do
      resources :tag_cloud, :only => :index, :module => :battles
    end

    get "s/:query", to: "battles#index", as: :search
    get "s",        to: "battles#index"
    get "s-cloud",  to: "battles/tag_cloud#index", as: :cloud
  end

  resolve "General::User" do |user, options|
    general_search_path(query: user.to_param)
  end

  ################################################################################ 将棋ウォーズ棋譜検索

  namespace :swars, path: "" do
    resources :battles, path: "wr", only: [:index, :show] do
      resources :tag_cloud, :only => :index, :module => :battles
    end

    get "w/:query", to: "battles#index", as: :search
    get "w",        to: "battles#index"
    get "w-cloud",  to: "battles/tag_cloud#index", as: :cloud
  end

  resolve "Swars::User" do |user, options|
    swars_search_path(query: user.to_param)
  end

  ################################################################################ 棋譜変換

  resources :free_battles, path: "x"

  resolve "FreeBattle" do |free_battle, options|
    [ns_prefix, free_battle, options]
  end

  ################################################################################ 戦法トリガー辞典

  resources :tactic_notes, path: "tactics", only: [:index, :show]

  get "tactics-tree",   to: "tactic_notes#index", defaults: {mode: "tree"}, as: :tree
  get "tactics-fortune", to: "tactic_notes#index", defaults: {mode: "fortune"}, as: :fortune

  ################################################################################ 符号入力ゲーム

  get "xy", to: "xy_game#show"

  ################################################################################ 局面編集

  get "position-editor", to: "position_editor#show", as: :position_editor

  ################################################################################ CPU対戦

  resource :cpu_versus, path: "cpu/versus", only: [:show, :create]
  get "cpu-versus", to: "cpu_versus#show"

  ################################################################################ 外部リンク

  direct :swars_real_battle do |battle, **options|
    options = {
      locale: "ja",
    }.merge(options)
    "http://kif-pona.heroz.jp/games/#{battle.battle_key}?#{options.to_query}"
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
