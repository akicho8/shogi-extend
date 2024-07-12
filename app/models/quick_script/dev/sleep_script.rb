module QuickScript
  module Dev
    class SleepScript < Base
      self.title = "1秒待つ"
      self.description = "レスポンスに必ず1秒かかる。ただしローディングエフェクトにより連打できない。"
      self.form_method = :get
      self.get_then_axios_get = true
      self.button_click_loading = true

      def call
        sleep(current_seonds)
        current_seonds
      end

      def current_seonds
        (params[:sleep].presence || 1).to_f
      end
    end
  end
end
