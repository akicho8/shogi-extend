module QuickScript
  module Dev
    class Post3SessionCounterScript < Base
      self.title = "POST実行3"
      self.description = "POSTボタンで送信したときだけセッションカウンタを更新する"
      self.form_method = :post

      def call
        session[:my_count] ||= 0
        if request_post?
          session[:my_count] += 1
        end
        session[:my_count]
      end
    end
  end
end
