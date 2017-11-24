Rails.application.routes.draw do
  namespace :name_space1, path: "k" do
    resources :kifu_convert_infos, path: "x"

    resources :battle_users
    resources :battle_records
    resources :battle_ships
  end

  # match 'r/:unique_key', to: 'name_space1/kifu_convert_infos#show', via: :get
  # match 'new',             to: 'name_space1/kifu_convert_infos#new', via: :get

  resolve "KifuConvertInfo" do |kifu_convert_info, options|
    # [:name_space1, kifu_convert_info, options]
    # "/r/#{kifu_convert_info.unique_key}"
    "x/#{kifu_convert_info.to_param}"
  end

  get "tops/show"
  get "swars_tops/show"

  get "s", to: "swars_tops#show"

  get "x", to: "name_space1/kifu_convert_infos#new"
  match "x/:id", to: "name_space1/kifu_convert_infos#show", via: :get

  # root "name_space1/kifu_convert_infos#new"
  # root "swars_tops#show"
  root "swars_tops#show"
end
