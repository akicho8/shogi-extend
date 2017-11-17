Rails.application.routes.draw do
  namespace :name_space1, path: "k" do
    resources :kifu_convert_infos, path: "x"
  end

  # match 'r/:unique_key', to: 'name_space1/kifu_convert_infos#show', via: :get
  # match 'new',             to: 'name_space1/kifu_convert_infos#new', via: :get

  resolve "KifuConvertInfo" do |kifu_convert_info, options|
    [:name_space1, kifu_convert_info, options]
    # "/r/#{kifu_convert_info.unique_key}"
  end

  get "tops/show"
  root "name_space1/kifu_convert_infos#new"
end
