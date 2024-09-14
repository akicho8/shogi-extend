# def call
#   if running_in_foreground
#     if request_post?
#       call_later
#     end
#   end
#
#   if running_in_background
#     AppLog.important(subject: "バックグラウンド実行完了", body: params)
#   end
# end

module QuickScript
  concern :BackgroundMod do
    def running_in_background
      @options[:running_in_background].to_s == "true"
    end

    def running_in_foreground
      !running_in_background
    end

    def call_later
      if running_in_background
        raise QuickScriptError, "バックグラウンドでさらにバックグラウンド実行するべからず"
      end
      new_params = params.merge(qs_group_key: self.class.qs_group_key, qs_page_key: self.class.qs_page_key)
      QuickScriptJob.perform_later(new_params, current_user_id: current_user&.id, admin_user: admin_user)
    end
  end
end
