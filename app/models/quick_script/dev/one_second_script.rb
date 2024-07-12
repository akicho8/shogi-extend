module QuickScript
  module Dev
    class OneSecondScript < Base
      self.title = "1秒待つ"
      self.description = "レスポンスに必ず1秒かかる"
      self.form_method = :get
      self.get_then_axios_get = true

      def call
        seconds = (params[:sleep].presence || 1).to_f
        sleep(seconds)
        seconds
      end
    end
  end
end
