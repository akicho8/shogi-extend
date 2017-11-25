Rails.application.routes.draw do
  namespace :name_space1, path: "" do
    resources :convert_infos, path: "x"

    resources :wars_users
    resources :wars_records
    resources :wars_ships
  end

  # match 'r/:unique_key', to: 'name_space1/convert_infos#show', via: :get
  # match 'new',             to: 'name_space1/convert_infos#new', via: :get

  resolve "ConvertInfo" do |convert_info, options|
    [:name_space1, convert_info, options]
    # "/x/#{convert_info.to_param}"
  end

  resolve "WarsUser" do |wars_user, options|
    search_by_user_path(user_key: wars_user.to_param)
  end

  get "tops/show"
  get "swars_tops/show"

  get "s/:user_key", to: "swars_tops#show", as: :search_by_user
  get "s", to: "swars_tops#show"

  # get "x/new", to: "name_space1/convert_infos#new"
  # match "x/:id", to: "name_space1/convert_infos#show", via: :get

  # root "name_space1/convert_infos#new"
  # root "swars_tops#show"
  root "swars_tops#show"

  direct :swars_board do |wars_record|
    "http://kif-pona.heroz.jp/games/#{wars_record.battle_key}?locale=ja"
  end
end
