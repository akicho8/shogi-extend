module QuickScript
  module Swars
    class PrisonNewScript < Base
      self.title = "将棋ウォーズ囚人登録"
      self.description = "指定のウォーズIDを囚人とする"
      self.form_method = :post
      self.button_label = "登録"
      self.throttle_expires_in = Rails.env.local? ? 1.seconds : 10.seconds

      def form_parts
        super + [
          {
            :label       => "囚人のウォーズID",
            :key         => :swars_user_key,
            :type        => :string,
            :dynamic_part => -> {
              {
                :default     => params[:swars_user_key],
                :placeholder => "AKABAN_TARO",
              }
            },
          },
        ]
      end

      def call
        if request_post?
          if current_swars_user_key.blank?
            flash[:notice] = "囚人のウォーズIDを入力してください"
            return
          end
          unless throttle.call
            flash[:notice] = "あと #{throttle.ttl_sec} 秒待ってから実行してください"
            return
          end
          my_page = ::Swars::Agent::MyPage.new(user_key: current_swars_user_key)
          if my_page.page_not_found?
            flash[:notice] = "#{current_swars_user_key} が見つかりません"
            return
          end
          user_key = my_page.real_user_key
          user = ::Swars::User.find_or_create_by!(user_key: user_key)
          if params[:fake]
          else
            if !my_page.ban?
              flash[:notice] = "#{user_key} はBANされていません"
              return
            end
            if user.ban?
              flash[:notice] = "#{user_key} は登録済みです"
              return
            end
            user.ban!
          end
          flash[:notice] = "#{user_key} を追加しました"
          AppLog.info(subject: "[囚人][追加][#{user_key}]")
          redirect_to "/lab/swars/prison-search"
          nil
        end
      end

      def current_swars_user_key
        params[:swars_user_key].to_s.strip.presence
      end
    end
  end
end
