module QuickScript
  module Dev
    class Post3SessionCounterScript < Base
      self.title = "POST実行3"
      self.description = "POSTボタンで送信したときだけセッションカウンタを更新する"
      self.form_method = :post

      def call
        @session = {}
        if controller
          @session = controller.session
        end
        @session[:my_counter] = @session[:my_counter].to_i
        if request_post?
          @session[:my_counter] += 1
        end
        @session[:my_counter]
      end
    end
  end
end
