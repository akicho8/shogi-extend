module QuickScript
  module Dev
    class PostAndRedirectScript < Base
      self.title = "POSTしてリダイレクト"
      self.description = "flash[:notice] 付き"
      self.form_method = :post

      def call
        if request_post?
          flash[:notice] = "投稿しました"
          redirect_to "/lab/dev/null"
        end
      end
    end
  end
end
