module QuickScript
  module Dev
    class Post1Script < Base
      self.title = "POST実行1"
      self.description = "サーバー側で POST or GET を判別する"
      self.form_method = :post

      def call
        request_post?
      end
    end
  end
end
