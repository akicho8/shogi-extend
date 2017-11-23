module NameSpace1
  class BattleUsersController < ApplicationController
    if Rails.env.production?
      if v = ENV["HTTP_BASIC_AUTHENTICATE"].presence
        http_basic_authenticate_with Hash[[:name, :password].zip(v.split(/:/))].merge(only: [:index, :edit, :update, :destroy])
      end
    end

    include PluggableCrud::All

    def show
      respond_to do |format|
        format.html
        format.kif { kifu_send_data }
        format.ki2 { kifu_send_data }
        format.csa { kifu_send_data }
      end
    end

    private

    # def record_load
    #   unless params[:id]
    #     current_scope.create!(:user_key)
    #   end
    #   super
    # end

    # def create
    #   if user_key = current_record_params[:user_key].presence
    #     unless current_scope.find_by(user_key: user_key)
    #       current_scope.create!()
    #       user_key
    #     end
    #   end
    #   super
    # end

    # def record_load
    #   unless params[:id]
    #     current_scope.create!(:user_key)
    #   end
    #   super
    # end

    # def create_or_update
    #   # unless current_record
    #   #   if params[:id]
    #   #     self.current_record = current_model.create!(user_key: params[:id])
    #   #   end
    #   # end
    #
    #   if v = params[:id].presence
    #     current_scope.find_by(user_key: v)
    #   end
    #
    #   self.current_record = current_scope.create!(user_key: params[:id])
    #
    #   super
    # end

    # def create
    #   if v = params[:id].presence
    #     unless current_scope.find_by(user_key: v)
    #
    #     end
    #
    #     self.current_record = current_model.create!(user_key: params[:id])
    #   end
    #
    #
    # end

    def raw_current_record
      if v = params[:id].presence
        current_scope.find_by(user_key: v)
      else
        current_scope.new
      end
    end

    # 更新後の移動先
    def redirect_to_where
      # current_record
      [self.class.parent_name.underscore, current_record]
    end

    # def notice_message
    #   "変換完了！"
    # end
    #
    # def kifu_send_data
    #   filename = Time.current.strftime("#{current_filename}_%Y_%m_%d_%H%M%S.#{params[:format]}").encode(current_encode)
    #   send_data(current_record.send("converted_#{params[:format]}"), type: Mime[params[:format]], filename: filename, disposition: true ? "inline" : "attachment")
    # end
    #
    # def current_filename
    #   params[:filename].presence || "棋譜データ"
    # end
    #
    # def current_encode
    #   params[:encode].presence || current_encode_default
    # end
    #
    # def current_encode_default
    #   if request.user_agent.to_s.match(/Windows/i)
    #     "Shift_JIS"
    #   else
    #     "UTF-8"
    #   end
    # end
    #
    # rescue_from "Bushido::BushidoError" do |exception|
    #   h = ApplicationController.helpers
    #   lines = exception.message.lines
    #   message = lines.first.strip.html_safe
    #   if field = lines.drop(1).join.presence
    #     message += "<br>".html_safe
    #     message += h.content_tag(:pre, field).html_safe
    #   end
    #   unless Rails.env.production?
    #     if exception.backtrace
    #       message += h.content_tag(:pre, exception.backtrace.first(8).join("\n").html_safe).html_safe
    #     end
    #   end
    #   flash.now[:alert] = message
    #   render :edit
    # end
  end
end
