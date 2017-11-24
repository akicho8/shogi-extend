class SwarsTopsController < ApplicationController
  def show
    # WarsUser.destroy_all
    # WarsRecord.destroy_all
    # WarsRecord.destroy_all

    if current_user_key
      before_count = 0
      if wars_user = WarsUser.find_by(user_key: current_user_key)
        before_count = wars_user.wars_records.count
      end

      WarsRecord.import_all(user_key: current_user_key)

      @wars_user = WarsUser.find_by(user_key: current_user_key)
      if @wars_user
        count_diff = @wars_user.wars_records.count - before_count
        if count_diff.zero?
        else
          flash.now[:info] = "#{count_diff}件新しく取り込みました"
        end
      else
        flash.now[:warning] = "#{current_user_key} さんのデータは見つかりませんでした"
      end
    end
  end

  def current_user_key
    if Rails.env.development?
      # params[:user_key] = "hanairobiyori"
    end
    params[:user_key].to_s.gsub(/\p{blank}/, " ").strip.presence
  end

  rescue_from "Mechanize::ResponseCodeError" do |exception|
    notify_airbrake(exception)
    flash.now[:warning] = "該当のユーザーが見つかりません"
    if Rails.env.development?
      flash.now[:alert] = "#{exception.class.name}: #{exception.message}"
    end
    render :show
  end
end
