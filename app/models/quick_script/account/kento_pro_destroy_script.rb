module QuickScript
  module Account
    class KentoProDestroyScript < Base
      self.title = "KENTO Pro 解約"
      self.description = "KENTO Pro を解約する"
      self.form_method = :post
      self.button_label = "KENTO に移動する"

      def call
        if request_get?
          return { _autolink: "SHOGI-EXTEND (このサイト) と、KENTO は根本的に異なります。KENTO Pro を解約するには KENTO のサイトで手続きを進めてください。" }
        end
        if request_post?
          redirect_to "https://www.kento-shogi.com/", type: :hard
          self.main_component = nil
          return
        end
      end
    end
  end
end
