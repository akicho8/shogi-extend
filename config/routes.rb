Rails.application.routes.draw do
  namespace :name_space1, path: "" do
    resources :convert_source_infos, path: "x"

    resources :war_users
    resources :war_records, path: "r"
    resources :war_ships
  end

  # match 'r/:unique_key', to: 'name_space1/convert_source_infos#show', via: :get
  # match 'new',             to: 'name_space1/convert_source_infos#new', via: :get

  resolve "ConvertSourceInfo" do |convert_source_info, options|
    [:name_space1, convert_source_info, options]
  end

  resolve "WarUser" do |war_user, options|
    search_by_user_path(user_key: war_user.to_param)
  end

  get "tops/show"
  get "swars_tops/show"

  get "s/:user_key", to: "swars_tops#show", as: :search_by_user
  get "s", to: "swars_tops#show"

  # get "x/new", to: "name_space1/convert_source_infos#new"
  # match "x/:id", to: "name_space1/convert_source_infos#show", via: :get

  # root "name_space1/convert_source_infos#new"
  # root "swars_tops#show"
  root "swars_tops#show"

  direct :swars_board do |war_record|
    "http://kif-pona.heroz.jp/games/#{war_record.battle_key}?locale=ja"
  end
end
