module QuickScript
  module Dev
    class Redirect1Script < Base
      self.title = "リダイレクト1 (内部)"
      self.description = "$router.push で移動する"

      def call
        redirect_to "/bin/dev/null"
      end
    end
  end
end
