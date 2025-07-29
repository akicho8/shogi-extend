module QuickScript
  module Swars
    class CrawlerBatchScript < Base
      self.title = "古い棋譜の補完"
      self.description = "古い棋譜を補完するために棋譜取得を予約する"
      self.form_method = :post
      self.button_label = "棋譜取得の予約"
      self.login_link_show = true

      def form_parts
        super + [
          {
            :label       => "将棋ウォーズID",
            :key         => :swars_user_key,
            :type        => :string,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :default     => params[:swars_user_key].to_s.presence,
                :placeholder => "BOUYATETSU5",
              }
            },
          },
          {
            :label       => "ZIPファイルの添付",
            :key         => :attachment_mode,
            :type        => :radio_button,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems   => { "nothing" => "しない", "with_zip" => "する" },
                :default => params[:attachment_mode].to_s.presence || "nothing",
              }
            },
          },
        ]
      end

      def call
        if request_get?
          self.body_position = :above
          return MarkdownInfo.fetch("棋譜取得の予約").to_box_content
        end
        if request_post?
          validate!
          if flash.present?
            return
          end
          record = current_user.swars_crawl_reservations.create(crawl_reservation_params)
          if record.errors.present?
            flash[:notice] = record.errors.full_messages.join(" ")
            return
          end
          flash[:notice] = "予約しました"
          return
        end
      end

      def current_swars_user_key
        params[:swars_user_key].to_s.strip.presence
      end

      def current_swars_user
        @current_swars_user ||= ::Swars::User[current_swars_user_key]
      end

      def current_attachment_mode
        params[:attachment_mode].to_s
      end

      def crawl_reservation_params
        {
          :target_user_key => current_swars_user_key,
          :attachment_mode => current_attachment_mode,
        }
      end

      def validate!
        unless current_user
          flash[:notice] = "完了後の通知を受け取るためにログインしてください"
          return
        end
        unless current_user.email_valid?
          flash[:notice] = "ちゃんとしたメールアドレスを登録してください"
          return
        end
        if current_swars_user_key.blank?
          flash[:notice] = "ウォーズIDを入力してください"
          return
        end
        unless current_swars_user
          flash[:notice] = "#{current_swars_user_key} さんは存在しません"
          return
        end
      end
    end
  end
end
