module QuickScript
  module Middleware
    concern :SessionMod do
      prepended do
        class_attribute :session_compress, default: false # 圧縮するか？ (一度有効にすると戻せないので有効にするな)
      end

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

      def scoped_session_set(key, value)
        if session_compress
          value = value_decode(value)
        end
        scoped_session[key.to_s] = value
      end

      def scoped_session_get(key)
        if value = scoped_session[key.to_s]
          begin
            if session_compress
              value_decode(value)
            else
              value
            end
          rescue Zlib::DataError, ArgumentError
            value
          end
        end
      end

      ################################################################################

      def value_decode(value)
        value = value.to_json
        value = Zlib::Deflate.deflate(value)
        value = Base64.strict_encode64(value)
      end

      def value_encode(value)
        value = Base64.strict_decode64(value)
        value = Zlib::Inflate.inflate(value)
        value = JSON.parse(value)
      end

      ################################################################################ DBを使うセッション

      def db_session_write(key, value)
        if current_user
          PermanentVariable[db_session_key(key)] = value
        end
      end

      def db_session_read(key)
        if current_user
          PermanentVariable[db_session_key(key)]
        end
      end

      def db_session_key(key)
        [current_user.id, self.class.qs_key, key].join("|")
      end

      ################################################################################

      def before_call
        Rails.logger.tagged("パラメータ復元と現在の値を保存") do
          form_parts.each do |e|
            key = e[:key]
            case e[:session_sync]
            when :use_db_session_for_login_user_only
              if current_user
                params[key] ||= db_session_read(key)
                db_session_write(key, params[key])
              end
            when true
              # :PARAMS_SERIALIZE_DESERIALIZE:
              # if params[key] == "__empty__"
              #   Rails.logger.debug { "params = params.except(#{key.inspect})" }
              #   self.params = params.except(key)
              #   p ["#{__FILE__}:#{__LINE__}", __method__, params]
              # else
              value = scoped_session_get(key)
              Rails.logger.debug { "params[#{key.inspect}] #{params[key].inspect} ||= #{value.inspect}" }
              params[key] ||= value # scoped_session 側のハッシュのキーは文字列になってしまう点に注意する
              # end
              Rails.logger.debug { "scoped_session[#{key.to_s.inspect}] = #{params[key].inspect}" }
              scoped_session_set(key, params[key])
            end
          end
        end
        super
      end
    end
  end
end
