Rails.application.routes.draw do
  resources :about, only: :show

  get "health" => HealthResponder

  get "talk", to: "talk#show", as: :talk

  devise_for :xusers, {
    class_name: "Colosseum::User",
    controllers: {
      omniauth_callbacks: "colosseum/omniauth_callbacks",
      # sessions: "users/sessions",
    },
  }

  ################################################################################ 対戦

  namespace :colosseum do
    resources :battles
    resources :users
    resources :rankings, only: :index
  end

  # root "colosseum/battles#index"
  root "swars/battles#index"

  ################################################################################ Debug

  match 'eval', to: "eval#run", via: [:get, :post, :put, :delete]

  ################################################################################ ログアウト

  namespace :colosseum, path: "" do
    resource :session, only: [:create, :destroy]
  end

  ################################################################################ 将棋ウォーズ棋譜検索

  namespace :swars, path: "" do
    resources :battles, path: "w"
    resources :player_infos, :only => :index, path: "w-user-stat"

    get "wr/:id",   to: "battles#show" # 互換性のため

    get "w",        to: "battles#index", as: :basic
    get "w-light",  to: "battles#index", as: :light
  end

  resolve "Swars::User" do |user, options|
    swars_basic_path(query: user.to_param)
  end

  ################################################################################ 棋譜投稿

  resources :free_battles, path: "x"

  get "transport", to: "free_battles#new", defaults: { edit_mode: "transport" }

  # resolve "FreeBattle" do |free_battle, options|
  #   [ns_prefix, free_battle, options]
  # end

  ################################################################################ 戦法トリガー事典

  resources :tactic_notes, path: "tactics", only: [:index, :show]

  get "tactics-tree",    to: "tactic_notes#index", defaults: {mode: "tree"},    as: :tree
  get "tactics-fortune", to: "tactic_notes#index", defaults: {mode: "fortune"}, as: :fortune

  ################################################################################ 符号の鬼

  resource :stopwatch, only: [:show, :create]
  resource :vs_clock, only: [:show, :create]
  resource :simple_board, path: "board", only: [:show, :create]

  resources :xy_records, path: "xy", only: [:index, :create, :update]

  ################################################################################ 局面編集

  get "position-editor", to: "position_editor#show", as: :position_editor

  ################################################################################ CPU対戦

  resource :cpu_battles, path: "cpu/battles", only: [:show, :create]
  get "cpu/battles", to: "cpu_battles#show"

  ################################################################################ 外部リンク

  direct :swars_real_battle do |battle, **options|
    # options = {
    #   locale: "ja",
    # }.merge(options)
    #
    # "https://shogiwars.heroz.jp/games/#{battle.key}?#{options.to_query}"
    "https://shogiwars.heroz.jp/games/#{battle.key}"
  end

  direct :swars_home do |user, **options|
    options = {
      locale: "ja",
    }.merge(options)
    "https://shogiwars.heroz.jp/users/mypage/#{user.user_key}?#{options.to_query}"
  end

  direct :piyo_shogi_app do |url|
    "piyoshogi://?url=#{url}"
  end

  direct :kento_app do |url, **options|
    options = {
      kifu: url,
    }.merge(options)

    "https://www.kento-shogi.com/?#{options.to_query}"
  end

  direct :google_search do |query|
    "https://www.google.co.jp/search?source=ig&hl=ja&lr=lang_ja&q=#{query}"
  end

  direct :twitter_search do |query|
    # "https://search.yahoo.co.jp/realtime/search?p=#{query}&ei=UTF-8"
    "https://twitter.com/search?q=#{query}"
  end

  direct :google_maps do |query|
    "https://www.google.co.jp/maps/search/#{query}"
  end

  direct :youtube_search do |query|
    "https://www.youtube.com/results?search_query=#{query}&search=Search"
  end

  direct :production_app do
    "http://tk2-221-20341.vs.sakura.ne.jp/shogi"
    # "http://shogi-flow.xyz/"
  end

  ################################################################################ admin

  # namespace :admin do
  #   resources :users
  #   root "users#index"
  # end
end
