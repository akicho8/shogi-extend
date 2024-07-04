module QuickScript
  module Dev
    class SessionCounterScript < Base
      self.title = "セッションカウンタ"
      self.description = "連打防止機能付き"
      self.form_method = :get
      self.params_add_submit_key = :exec
      self.router_push_failed_then_fetch = true

      def call
        self.button_label = count
        if submitted?
          unless throttle.run
            return "あと #{throttle.ttl_sec} 秒待ってから実行してください (あと #{throttle.ttl_ms} ms)"
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
