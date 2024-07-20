# def call
#   if foreground_mode
#     if request_post?
#       call_later
#     end
#   end
#
#   if background_mode
#     AppLog.important(subject: "バックグランド実行完了", body: params)
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
        raise QuickScriptError, "バックグランドでさらにバックグラウンド実行するべからず"
      end
      QuickScriptJob.perform_later(params, current_user_id: current_user&.id, admin_user: admin_user)
    end
  end
end
