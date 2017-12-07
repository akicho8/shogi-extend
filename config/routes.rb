Rails.application.routes.draw do
  namespace :resource_ns1, path: "" do
    resources :free_battle_records, path: "x"

    resources :battle_users
    resources :battle_records, path: "r"
    resources :battle_ships
  end

  # match 'r/:unique_key', to: 'resource_ns1/free_battle_records#show', via: :get
  # match 'new',             to: 'resource_ns1/free_battle_records#new', via: :get

  resolve "FreeBattleRecord" do |free_battle_record, options|
    [:resource_ns1, free_battle_record, options]
  end

  resolve "BattleUser" do |battle_user, options|
    query_search_path(query: battle_user.to_param)
  end

  get "tops/show"
  get "swars_tops/show"

  get "s/:query", to: "swars_tops#show", as: :query_search
  get "s", to: "swars_tops#show"
  get "cloud", to: "swars_tops#tag_cloud"

  # get "x/new", to: "resource_ns1/free_battle_records#new"
  # match "x/:id", to: "resource_ns1/free_battle_records#show", via: :get

  # root "resource_ns1/free_battle_records#new"
  # root "swars_tops#show"
  root "swars_tops#show"

  direct :swars_board do |battle_record|
    "http://kif-pona.heroz.jp/games/#{battle_record.battle_key}?locale=ja"
  end

  direct :mountain_upload do
    "http://shogi-s.com/upload-text"
  end

  direct :piyo_link do |url|
    "piyoshogi://?url=#{url}"
  end
end
