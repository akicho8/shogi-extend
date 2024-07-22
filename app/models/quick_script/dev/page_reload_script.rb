module QuickScript
  module Dev
    class PageReloadScript < Base
      self.title = "ページリロード"
      self.description = "クライアント側で location.href にセットする"
      self.form_method = :post

      def call
        if request_post?
          # self.navibar_show = false
          # self.form_method = nil
          page_reload
        end
      end
    end
  end
end
