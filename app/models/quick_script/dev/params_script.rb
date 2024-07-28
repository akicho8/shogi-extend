module QuickScript
  module Dev
    class ParamsScript < Base
      self.title = "パラメータ確認"
      self.description = "params を表示する"
      self.form_method = :post

      def call
        AppLog.important(subject: "params", body: params.inspect)
        params
      end
    end
  end
end
