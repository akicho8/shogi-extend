module Swars
  class PlayerInfosController < ApplicationController
    def index
      if current_user_key
        Battle.basic_import(user_key: current_user_key, page_max: 3)
        if current_swars_user
          @stat1 = current_swars_user.stat1
          @stat2 = current_swars_user.stat2
        end
      end
    end

    let :current_user_key do
      params[:user_key].to_s.strip.presence
    end

    let :current_swars_user do
      User.find_by(user_key: current_user_key)
    end
  end
end
