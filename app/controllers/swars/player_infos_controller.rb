module Swars
  class PlayerInfosController < ApplicationController
    def index
      if current_user_key
        Battle.debounce_basic_import(user_key: current_user_key, page_max: 3)
        unless current_swars_user
          flash.now[:warning] = "#{current_user_key} さんの情報は見つかりませんでした"
          return
        end
        SlackAgent.chat_post_message(key: "Wプレイヤー情報", body: "#{current_swars_user.user_key}")
      end
    end

    let :current_user_key do
      params[:user_key].to_s.strip.presence
    end

    let :current_swars_user do
      User.find_by(user_key: current_user_key)
    end

    rescue_from "ActiveRecord::RecordInvalid" do |exception|
      if exception.message.match?(/重複/)
        redirect_to [:swars, :player_infos], alert: "調べているところなので連打しないでください(^^)"
      else
        raise exception
      end
    end
  end
end
