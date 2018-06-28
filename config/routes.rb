# == Route Map
#
# ["/Users/ikeda/src/shogi_web/config/initializers/0180_active_model_serializers.rb:11", nil, :ams_sr]
# yarn check v1.7.0
# success Folder in sync.
# Done in 0.11s.
#                         Prefix Verb   URI Pattern                                                                              Controller#Action
#                  fanta_battles GET    /online/battles(.:format)                                                                fanta/battles#index
#                                POST   /online/battles(.:format)                                                                fanta/battles#create
#               new_fanta_battle GET    /online/battles/new(.:format)                                                            fanta/battles#new
#              edit_fanta_battle GET    /online/battles/:id/edit(.:format)                                                       fanta/battles#edit
#                   fanta_battle GET    /online/battles/:id(.:format)                                                            fanta/battles#show
#                                PATCH  /online/battles/:id(.:format)                                                            fanta/battles#update
#                                PUT    /online/battles/:id(.:format)                                                            fanta/battles#update
#                                DELETE /online/battles/:id(.:format)                                                            fanta/battles#destroy
#                    fanta_users GET    /online/users(.:format)                                                                  fanta/users#index
#                                POST   /online/users(.:format)                                                                  fanta/users#create
#                 new_fanta_user GET    /online/users/new(.:format)                                                              fanta/users#new
#                edit_fanta_user GET    /online/users/:id/edit(.:format)                                                         fanta/users#edit
#                     fanta_user GET    /online/users/:id(.:format)                                                              fanta/users#show
#                                PATCH  /online/users/:id(.:format)                                                              fanta/users#update
#                                PUT    /online/users/:id(.:format)                                                              fanta/users#update
#                                DELETE /online/users/:id(.:format)                                                              fanta/users#destroy
#                           root GET    /                                                                                        fanta/battles#index
# general_battle_tag_cloud_index GET    /sr/:battle_id/tag_cloud(.:format)                                                       general/battles/tag_cloud#index
#                general_battles GET    /sr(.:format)                                                                            general/battles#index
#                 general_battle GET    /sr/:id(.:format)                                                                        general/battles#show
#                 general_search GET    /s/:query(.:format)                                                                      general/battles#index
#                      general_s GET    /s(.:format)                                                                             general/battles#index
#                  general_cloud GET    /s-cloud(.:format)                                                                       general/battles/tag_cloud#index
#   swars_battle_tag_cloud_index GET    /wr/:battle_id/tag_cloud(.:format)                                                       swars/battles/tag_cloud#index
#                  swars_battles GET    /wr(.:format)                                                                            swars/battles#index
#                   swars_battle GET    /wr/:id(.:format)                                                                        swars/battles#show
#                   swars_search GET    /w/:query(.:format)                                                                      swars/battles#index
#                        swars_w GET    /w(.:format)                                                                             swars/battles#index
#                    swars_cloud GET    /w-cloud(.:format)                                                                       swars/battles/tag_cloud#index
#                   free_battles GET    /x(.:format)                                                                             free_battles#index
#                                POST   /x(.:format)                                                                             free_battles#create
#                new_free_battle GET    /x/new(.:format)                                                                         free_battles#new
#               edit_free_battle GET    /x/:id/edit(.:format)                                                                    free_battles#edit
#                    free_battle GET    /x/:id(.:format)                                                                         free_battles#show
#                                PATCH  /x/:id(.:format)                                                                         free_battles#update
#                                PUT    /x/:id(.:format)                                                                         free_battles#update
#                                DELETE /x/:id(.:format)                                                                         free_battles#destroy
#                   tactic_notes GET    /tactics(.:format)                                                                       tactic_notes#index
#                    tactic_note GET    /tactics/:id(.:format)                                                                   tactic_notes#show
#                           tree GET    /tactics-tree(.:format)                                                                  tactic_notes#index {:mode=>"tree"}
#                        fortune GET    /tactics-fortune(.:format)                                                               tactic_notes#index {:mode=>"fortune"}
#                             xy GET    /xy(.:format)                                                                            xy_game#show
#                position_editor GET    /position-editor(.:format)                                                               position_editor#show
#                     cpu_battles GET    /cpu/versus(.:format)                                                                    cpu_battles#show
#                                POST   /cpu/versus(.:format)                                                                    cpu_battles#create
#                                GET    /cpu/battles(.:format)                                                                    cpu_battles#show
#             rails_service_blob GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
#      rails_blob_representation GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
#             rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
#      update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
#           rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create

Rails.application.routes.draw do
  namespace :fanta, path: "" do
    resources :battles, path: "online/battles"
    resources :users, path: "online/users"
  end

  root "fanta/battles#index"

  ################################################################################ Debug

  match 'eval', to: "eval#run", via: [:get, :post, :put, :delete]

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

  get "tactics-tree", to: "tactic_notes#index", defaults: {mode: "tree"}, as: :tree
  get "tactics-fortune", to: "tactic_notes#index", defaults: {mode: "fortune"}, as: :fortune

  ################################################################################ 符号入力ゲーム

  get "xy", to: "xy_game#show"

  ################################################################################ 局面編集

  get "position-editor", to: "position_editor#show", as: :position_editor

  ################################################################################ CPU対戦

  resource :cpu_battles, path: "cpu/battles", only: [:show, :create]
  get "cpu/battles", to: "cpu_battles#show"

  ################################################################################ 外部リンク

  direct :swars_real_battle do |battle, **options|
    options = {
      locale: "ja",
    }.merge(options)
    "http://kif-pona.heroz.jp/games/#{battle.key}?#{options.to_query}"
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
