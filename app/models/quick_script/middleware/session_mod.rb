module QuickScript
  module Middleware
    concern :SessionMod do
      def session
        if controller
          controller.session    # 通常
        else
          @session ||= {}       # バックグランド実行時 (or テスト時)
        end
      end

      ################################################################################

      def scoped_session
        session[self.class.name] ||= {}
      end

      # 手動で呼ぶことはないが form_parts にない値を保存する場合に直接使うかもしれない
      def params_restore_and_save_from_session(*keys)
        keys.each do |key|
          params[key] ||= scoped_session[key.to_s] # scoped_session 側のハッシュのキーは文字列になってしまう点に注意する
          scoped_session[key.to_s] = params[key]
        end
      end

      # form_parts で session_sync の印をつけたものだけ自動的に保存する
      def form_parts_restore_and_save_from_session_auto
        keys = form_parts.find_all { |e| e[:session_sync] }.collect { |e| e[:key] }
        params_restore_and_save_from_session(*keys)
      end

      # もともと call のなかで params_restore_and_save_from_session(:str1, :radio1) などのようにしていたが面倒だった。
      # そこで form_parts 側で印をつけたものだけを自動で(ほぼ意識の外で)保存する
      def before_call
        form_parts_restore_and_save_from_session_auto
        super
      end
    end
  end
end
