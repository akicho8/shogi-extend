module QuickScript
  module Middleware
    concern :SessionMod do
      def session
        if controller
          controller.session    # 通常
        else
          @session ||= {}       # バックグラウンド実行時 (or テスト時)
        end
      end

      ################################################################################

      def scoped_session
        session[self.class.name] ||= {}
      end

      def before_call
        form_parts.each do |e|
          if e[:session_sync]
            key = e[:key]
            params[key] ||= scoped_session[key.to_s] # scoped_session 側のハッシュのキーは文字列になってしまう点に注意する
            scoped_session[key.to_s] = params[key]
          end
        end
        super
      end
    end
  end
end
