module QuickScript
  module Dev
    class EvalScript < Base
      self.title = "eval 実行"
      self.description = "eval(params[:code]) する"

      def call
        eval(params[:code].to_s, binding, __FILE__, __LINE__)
      end
    end
  end
end
