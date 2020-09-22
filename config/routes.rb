Rails.application.routes.draw do
  root "tops#show"

  get "health" => HealthResponder

  devise_for :xusers, {
    class_name: "::User",
    controllers: {
      omniauth_callbacks: "omniauth_callbacks",
    },
  }

  ################################################################################ プロフィール編集など

  resources :users

  ################################################################################ Debug

  match "eval", to: "eval#run", via: :all

  ################################################################################ ログアウト

  # namespace :colosseum, path: "" do
  resource :direct_session, only: [:create, :destroy]
  # end

  get :login, to: "login#show"

  ################################################################################ 将棋ウォーズ棋譜検索

  namespace :swars, path: "" do
    resources :battles, path: "w"
  end

  resolve "Swars::User" do |user, options|
    swars_battles_path(query: user.to_param)
  end

  ################################################################################ 棋譜投稿

  resources :free_battles, path: "x"

  ################################################################################ 戦法トリガー事典

  resources :tactic_notes, path: "tactics", only: [:index, :show]

  get "tactics-tree",    to: "tactic_notes#index", defaults: {mode: "tree"},    as: :tree

  ################################################################################ 他サービス

  resource :share_board, path: "share-board", only: [:show]

  ################################################################################ 将棋トレーニングバトル

  match "training", to: "scripts#show", defaults: { id: "actb_app" }, via: [:get, :update]

  ################################################################################ scripts

  resources :scripts, :path => "script", :only => [:show, :update]

  ################################################################################ api

  # http://0.0.0.0:3000/ping
  # http://0.0.0.0:3000/ping.json
  # http://0.0.0.0:3000/ping.txt
  match "ping(.:format)", to: "api/etc#ping", via: :all, format: nil

  namespace :api, format: "json" do
    match "ping(.:format)", to: "etc#ping", via: :all, format: nil
    match "echo(.:format)", to: "etc#echo", via: :all, format: nil

    resource :general, only: [:show] do
      match "any_source_to", via: [:get, :post]
    end
    resource :talk, only: [:show, :create]
    resources :xy_records, path: "xy", only: [:index, :create, :update]
    resource :cpu_battle, only: [:show, :create]
    resource :share_board, only: [:show, :create]
    resource :three_stage_league, only: [:show]
    resource :three_stage_league_player, only: [:show]
    resource :swars_grade_histogram, only: [:show]
    resource :swars_histogram, only: [:show]
  end

  ################################################################################ admin

  namespace :admin do
    resource :session, only: :destroy
    resource :home, only: :show

    resources :scripts, path: "script", only: [:show, :update]

    resources :example_scripts, path: "example-script", only: [:show, :update]

    root "homes#show"
  end

  ################################################################################ sidekiq

  # require "sidekiq/monitor/stats" # <mounted-path>/monitor-stats
  require "sidekiq/web"
  mount Sidekiq::Web => "/admin/sidekiq" # authenticate :user {} で認証チェックする例がネットにあるが、それは devise のメソッド

  if Rails.env.production?
    Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
      [user, password] == ["admin", Rails.application.credentials[:admin_password]]
    end
  end

  if false
    # Sidekiq::Web.tabs.replace({"管理画面" => "/admin"}.merge(Sidekiq::Web.tabs))
    # Sidekiq::Web.tabs["管理画面に戻る"] = "/admin"
    Sidekiq::Web.tabs["管理画面に戻る"] = "http://localhost:3000/admin"
  end

  ################################################################################ 外部リンク

  direct :official_swars_battle do |battle, options = {}|
    "https://shogiwars.heroz.jp/games/#{battle.key}"
  end

  direct :swars_home do |user, options = {}|
    "https://shogiwars.heroz.jp/users/mypage/#{user.user_key}"
  end

  direct :piyo_shogi_app do |url, options|
    # if Rails.env.development?
    #   url = "http://wdoor.c.u-tokyo.ac.jp/shogi/LATEST//2016/09/24/wdoor+floodgate-600-10F+gpsfish_normal_1c+gps_l+20160924113005.csa"
    # end
    "piyoshogi://?#{options.to_query}&url=#{url}" # 渡すURLをエスケープするとぴよ将棋で読めなくなるので to_query してはいけない
  end

  direct :kento_app do |options, turn|
    "https://www.kento-shogi.com/?#{options.to_query}##{turn}"
  end

  direct :google_search do |query|
    "https://www.google.co.jp/search?q=#{query}"
  end

  direct :google_image_search do |query|
    "https://www.google.co.jp/search?tbm=isch&q=#{query}"
  end

  direct :twitter_search do |query|
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
    "https://shogi-flow.xyz/"
  end
end
