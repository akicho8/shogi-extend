module QuickScript
  module Dev
    class Redirect2Script < Base
      self.title = "リダイレクト2 (外部)"
      self.description = "外部サイトにリダイレクトする"

      def call
        redirect_to "https://example.com/", hard_jump: true
      end
    end
  end
end
