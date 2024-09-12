# def call
#   if foreground_mode
#     if request_post?
#       call_later
#     end
#   end
#
#   if background_mode
#     AppLog.important(subject: "バックグラウンド実行完了", body: params)
#   end
# end

module QuickScript
  concern :BackgroundMod do
    def background_mode
      @options[:background_mode].to_s == "true"
    end

    def foreground_mode
      !background_mode
    end

    def call_later
      if background_mode
        raise QuickScriptError, "バックグラウンドでさらにバックグラウンド実行するべからず"
      end
      new_params = params.merge(qs_group_key: self.class.qs_group_key, qs_page_key: self.class.qs_page_key)
      QuickScriptJob.perform_later(new_params, current_user_id: current_user&.id, admin_user: admin_user)
    end
  end
end
