module QuickScript
  module Swars
    class PrisonPostScript < Base
      self.title = "将棋ウォーズ囚人登録"
      self.description = "指定のウォーズIDが牢獄に入っていたら囚人とする"
      self.form_method = :post

      def form_parts
        super + [
          {
            :label       => "将棋ウォーズID",
            :key         => :swars_user_key,
            :type        => :string,
            :default     => params[:swars_user_key],
            :placeholder => "AKABAN_TARO",
          },
        ]
      end

      def call
        if request_post?
          if current_swars_user_key.blank?
            return "ウォーズIDを入力してください"
          end
          throttle

          mypage = ::Swars::Agent::Mypage.new(user_key: current_swars_user_key)
          if mypage.user_missing?
            return "#{current_swars_user_key} が見つかりません"
          end
          user_key = mypage.real_user_key
          user = ::Swars::User.find_or_create_by!(user_key: user_key)
          if !mypage.ban?
            return "#{user_key} はBANされていません"
          end
          if user.ban?
            return "#{user_key} はBANを確認済みです"
          end
          user.ban!
          flash[:notice] = "一覧に追加しました"
          redirect_to "/bin/swars/prison-search?query=#{user_key}"
          nil
        end
      end

      def current_swars_user_key
        params[:swars_user_key].to_s.strip.presence
      end
    end
  end
end
