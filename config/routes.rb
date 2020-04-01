Rails.application.routes.draw do
  resources :foo_articles
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

  # resolve "FreeBattle" do |record, options|
  #   [record, options]
  # end

  # resolve "FreeBattle" do |record, options|
  #   [record, options]
  # end

  get "adapter", to: "free_battles#new", defaults: { edit_mode: "adapter" }

  # resolve "FreeBattle" do |free_battle, options|
  #   [ns_prefix, free_battle, options]
  # end

  ################################################################################ 戦法トリガー事典

  resources :tactic_notes, path: "tactics", only: [:index, :show]

  get "tactics-tree",    to: "tactic_notes#index", defaults: {mode: "tree"},    as: :tree
  get "tactics-fortune", to: "tactic_notes#index", defaults: {mode: "fortune"}, as: :fortune

  ################################################################################ 符号の鬼

  resource :stopwatch, only: [:show, :create]
  resource :simple_board, path: "board", only: [:show, :create]

  resources :xy_records, path: "xy", only: [:index, :create, :update]

  ################################################################################ 局面編集

  get "position-editor", to: "position_editor#show", as: :position_editor

  ################################################################################ CPU対戦

  resource :cpu_battles, path: "cpu/battles", only: [:show, :create]
  get "cpu/battles", to: "cpu_battles#show"

  ################################################################################ 外部リンク

  direct :official_swars_battle do |battle, **options|
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

  # 【需要】渡すURLをエスケープしてはいけない
  direct :piyo_shogi_app do |url|
    if Rails.env.development?
      url = "http://wdoor.c.u-tokyo.ac.jp/shogi/LATEST//2016/09/24/wdoor+floodgate-600-10F+gpsfish_normal_1c+gps_l+20160924113005.csa"
    end
    "piyoshogi://?url=#{url}"
  end

  direct :kento_app do |**options|
    # if Rails.env.development?
    #   options[:kifu] = "https://www.shogi-extend.com/x/e63d5d2a3ccd460676a6b6265c1a0c2d.kif"
    # end

    # options = {
    # }.merge(options)

    "https://www.kento-shogi.com/?#{options.to_query}"
  end

  direct :google_search do |query|
    "https://www.google.co.jp/search?q=#{query}"
  end

  direct :google_image_search do |query|
    "https://www.google.co.jp/search?tbm=isch&q=#{query}"
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
    "https://www.shogi-extend.com/"
  end

  direct :staging_app do
    "https://staging.shogi-extend.com/"
  end

  ################################################################################ scripts

  resources :scripts, :path => "script", :only => [:show, :update]

  ################################################################################ admin

  namespace :admin do
    resource :session, only: :destroy
    resource :home, only: :show

    resources :scripts, path: "script", only: [:show, :update]

    resources :example_scripts, path: "example-script", only: [:show, :update]

    root "homes#show"

    ################################################################################ fastentry

    if true
      require "fastentry/engine"

      if Rails.env.production? || Rails.env.staging?
        Fastentry::ApplicationController.http_basic_authenticate_with name: "admin", password: Rails.application.credentials[:admin_password]
      end

      # http://localhost:3000/admin/rails-cache
      mount Fastentry::Engine, at: "rails-cache"
    end
  end
end
