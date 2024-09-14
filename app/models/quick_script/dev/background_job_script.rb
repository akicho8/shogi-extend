module QuickScript
  module Dev
    class BackgroundJobScript < Base
      self.title = "バックグラウンド実行"
      self.description = "ActiveJob であとで実行する"
      self.form_method = :post

      def call
        if running_in_foreground
          if request_post?
            call_later
            self.button_label = "実行(#{params[:post_index]})"
            return { _autolink: controller&.admin_script_url(id: "app-log") }
          end
        end

        if running_in_background
          AppLog.important(subject: "バックグラウンド実行完了(#{params[:post_index]})", body: params)
        end
      end
    end
  end
end
