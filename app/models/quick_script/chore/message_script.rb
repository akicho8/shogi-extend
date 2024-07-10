module QuickScript
  module Chore
    class MessageScript < Base
      self.title = "メッセージ表示"
      self.description = "引数のメッセージを表示する"

      def call
        content = []
        if params[:message]
          content << h.simple_format(params[:message], :class => "block")
        end
        if params[:return_to]
          content << tag.p(:class => "block") { tag.a("戻る", :href => params[:return_to], :class => "button is-primary") }
        end
        tag.div { content.join.html_safe }
      end

      def title
        ""
      end
    end
  end
end
