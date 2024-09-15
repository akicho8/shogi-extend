module QuickScript
  module Dev
    class EvalScript < Base
      self.title = "eval 実行"
      self.description = "eval(params[:code]) する"
      self.form_method = :get
      self.router_push_failed_then_fetch = true

      def form_parts
        super + [
          {
            :label   => "コード",
            :key     => :code,
            :type    => :text,
            :default => -> { params[:code] },
          },
        ]
      end

      def call
        eval(params[:code].to_s, binding, __FILE__, __LINE__)
      end
    end
  end
end
