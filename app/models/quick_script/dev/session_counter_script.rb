module QuickScript
  module Dev
    class SessionCounterScript < Base
      self.title = "セッションカウンタ"
      self.description = "Redis を使って内部で連打を防止する"
      self.form_method = :get
      self.params_add_submit_key = :exec
      self.router_push_failed_then_fetch = true
      self.get_then_axios_get = true

      def call
        self.button_label = count
        if submitted?
          unless throttle.call
            return "あと #{throttle.ttl_sec} 秒待ってから実行しよう (あと #{throttle.ttl_ms} ms)"
          end
          self.count += 1
          self.button_label = count
        end
        nil
      end

      def count
        session[:my_count] || 0
      end

      def count=(value)
        session[:my_count] = value
      end
    end
  end
end
