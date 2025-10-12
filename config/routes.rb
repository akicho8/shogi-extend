Rails.application.routes.draw do
  scope "/admin" do
    mount MaintenanceTasks::Engine, at: "/maintenance_tasks"
  end

  root "tops#show"

  get "health" => HealthResponder

  devise_for :xusers, {
    class_name: "::User",
    controllers: {
      omniauth_callbacks: "omniauth_callbacks",
    },
  }

  ################################################################################ プロフィール編集など

  resources :users, path: "accounts"

  ################################################################################ Debug

  match "eval", to: "eval#run", via: :all

  ################################################################################ ShortUrl

  get "u/:key", to: "short_url/components#show"

  ################################################################################ ログアウト

  # namespace :colosseum, path: "" do
  resource :direct_session, only: [:create, :destroy]
  # end

  get :login, to: "login#show"

  ################################################################################ 将棋ウォーズ棋譜検索

  swars_search_shared_redirect_block = -> (params, request) {
    query = request.params.except(:format).to_query.presence
    path = nil

    # http://localhost:3000/w?flip=false&modal_id=DevUser1-YamadaTaro-20200101_123401&turn=34
    if !path
      if modal_id = request.params[:modal_id]
        path = { path: "/swars/battles/#{modal_id}", query: query }
      end
    end

    # http://localhost:3000/w?query=DevUser1&latest_open_index=0&external_app_key=piyo_shogi
    if !path
      if request.params[:latest_open_index]
        user_key = request.params[:query]
        external_app_key = params[:external_app_key] || :piyo_shogi
        path = "/swars/users/#{user_key}/direct-open/#{external_app_key}"
      end
    end

    # http://localhost:3000/w?query=DevUser1&user_stat_show=true
    if !path
      if request.params[:user_stat_show]
        user_key = request.params[:query]
        path = "/swars/users/#{user_key}"
      end
    end

    # http://localhost:3000/w?query=DevUser1
    if !path
      path = { path: "/swars/search", query: query }
    end

    UrlProxy.url_for(path)
  }

  get "w", format: "html", to: redirect(&swars_search_shared_redirect_block)

  namespace :swars, path: "" do
    resources :battles, path: "w"
  end

  resolve "Swars::User" do |user, options|
    swars_battles_path(query: user.to_param)
  end

  ################################################################################ 棋譜投稿

  resources :free_battles, path: "x"

  ################################################################################ 他サービス

  # 共有将棋盤
  # 本当は /api 側だけを使いたいが拡張子がついた /share-board.png などに対応するために設置してある
  resource :share_board, path: "share-board", only: [:show]

  namespace :kiwi, path: "" do
    resources :lemons, path: "animation-files", only: [:show]
  end

  ################################################################################ 将棋トレーニングバトル

  resources :scripts, :path => "script", :only => [:show, :update]

  ################################################################################ api

  # http://localhost:3000/ping
  # http://localhost:3000/ping.json
  # http://localhost:3000/ping.txt
  match "ping(.:format)", to: "api/etc#ping", via: :all, format: nil

  namespace :api, format: "json" do
    match "ping(.:format)",                      to: "etc#ping",               via: :all, format: nil
    match "echo(.:format)",                      to: "etc#echo",               via: :all, format: nil
    match "sleep(.:format)",                     to: "etc#sleep",              via: :all, format: nil
    match "general/any_source_to(.:format)",     to: "generals#any_source_to", via: :all, format: nil
    match "lab/:qs_group_key/:qs_page_key(.:format)", to: "quick_scripts#show",     via: :all, format: nil
    match "public/*path(.:format)",              to: "public_api#show",        via: :all, format: nil

    post "app_log(.:format)", to: "etc#app_log"

    get "swars/download_config_fetch(.:format)", to: "swars#download_config_fetch"
    get "swars/custom_search_setup(.:format)",   to: "swars#custom_search_setup"
    get "swars/user_stat(.:format)",             to: "swars#user_stat"

    namespace :wkbk, format: :json do
      namespace :tops do
        get :index
        get :sitemap
      end
      namespace :books do
        get :top
        get :index
        get :show
        get :edit
        post :save
        delete :destroy
        get :download
      end
      namespace :articles do
        get :index
        get :show
        get :edit
        post :save
        delete :destroy
      end
      namespace :answer_logs do
        post :create
      end
    end

    namespace :short_url, format: :json do
      resources :components, only: :create
    end

    resource :session, only: [] do
      get :auth_user_fetch
      delete :auth_user_logout   # ログアウト
      delete :auth_user_destroy   # 退会
    end

    resource :adapter, only: [] do
      get :formal_sheet
      post :record_create
    end

    namespace :kiwi, format: :json do
      namespace :tops do
        get :index
        get :sitemap
      end
      namespace :bananas do
        get :index
        get :show
        get :edit
        post :save
        delete :destroy
        get :download
      end
      namespace :lemons do
        get :index
        get :xresource_fetch
        post :record_create
        post :retry_run                  # for staff
        post :destroy_run                  # for staff
        post :all_info_reload # for staff
        post :zombie_kill_now # for staff
        post :background_job_kick # for staff
        post :zombie_kill
        if Rails.env.development?
          get :record_create
          get :retry_run
          get :destroy_run
          get :all_info_reload
          get :zombie_kill_now
          get :background_job_kick
          get :zombie_kill
        end
      end
    end

    namespace :xy_master, format: "json" do
      resources :time_records, only: [:index, :create, :update]
    end

    resource :talk, only: :create
    resources :app_entry_infos, only: :index
    resources :users, only: [:show]
    resource :cpu_battle, only: [:show, :create]

    # 共有将棋盤用API
    resource :share_board, only: [:show, :create] do
      post :kifu_mail
      get :kifu_mail if Rails.env.development?
      post :battle_create
      get :battle_create if Rails.env.development?
      get :dashboard
      get :chat_message_loader
      get :room_restore
    end
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
      [user, password] == ["admin", Rails.application.credentials[:basic_auth_password]]
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
