module QuickScript
  module Dev
    class PostAndRedirectScript < Base
      self.title = "POSTしてメッセージ付きリダイレクト"
      self.description = "POST で送信したときだけフォームのカウンタを更新する"
      self.form_method = :post

      def call
        if request_post?
          flash[:notice] = "投稿しました"
          redirect_to "/bin/dev/null"
        end
      end
    end
  end
end
