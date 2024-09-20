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
        Rails.logger.tagged("パラメータ復元と現在の値を保存") do
          form_parts.each do |e|
            if e[:session_sync]
              key = e[:key]
              # :PARAMS_SERIALIZE_DESERIALIZE:
              # if params[key] == "__empty__"
              #   Rails.logger.debug { "params = params.except(#{key.inspect})" }
              #   self.params = params.except(key)
              #   p ["#{__FILE__}:#{__LINE__}", __method__, params]
              # else
              Rails.logger.debug { "params[#{key.inspect}] #{params[key].inspect} ||= #{scoped_session[key.to_s].inspect}" }
              params[key] ||= scoped_session[key.to_s] # scoped_session 側のハッシュのキーは文字列になってしまう点に注意する
              # end
              Rails.logger.debug { "scoped_session[#{key.to_s.inspect}] = #{params[key].inspect}" }
              scoped_session[key.to_s] = params[key]
            end
          end
        end
        super
      end
    end
  end
end
