module QuickScript
  module Dev
    class Redirect1Script < Base
      self.title = "リダイレクト1"
      self.description = "$router.push で移動する"

      def call
        redirect_to "/bin/dev/blank"
      end
    end
  end
end
