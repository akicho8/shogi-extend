Rails.application.routes.draw do
  namespace :name_space1, path: "" do
    resources :convert_source_infos, path: "x"

    resources :battle_users
    resources :battle_records, path: "r"
    resources :battle_ships
  end

  # match 'r/:unique_key', to: 'name_space1/convert_source_infos#show', via: :get
  # match 'new',             to: 'name_space1/convert_source_infos#new', via: :get

  resolve "ConvertSourceInfo" do |convert_source_info, options|
    [:name_space1, convert_source_info, options]
  end

  resolve "BattleUser" do |battle_user, options|
    search_by_user_path(battle_user_key: battle_user.to_param)
  end

  get "tops/show"
  get "swars_tops/show"

  get "s/:battle_user_key", to: "swars_tops#show", as: :search_by_user
  get "s", to: "swars_tops#show"

  # get "x/new", to: "name_space1/convert_source_infos#new"
  # match "x/:id", to: "name_space1/convert_source_infos#show", via: :get

  # root "name_space1/convert_source_infos#new"
  # root "swars_tops#show"
  root "swars_tops#show"

  direct :swars_board do |battle_record|
    "http://kif-pona.heroz.jp/games/#{battle_record.battle_key}?locale=ja"
  end

  direct :sanmyaku_upload_text do
    "http://shogi-s.com/upload-text"
  end

  direct :piyo_link do |url|
    "piyoshogi://?url=#{url}"
  end
end
