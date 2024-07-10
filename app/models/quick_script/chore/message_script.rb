module QuickScript
  module Chore
    class MessageScript < Base
      self.title = "メッセージ表示"
      self.description = "引数のメッセージを表示する"

      def call
        content = []
        if v = params[:message]
          content << h.simple_format(v, :class => "block")
        end
        if v = params[:return_to]
          content << tag.p(:class => "block") { tag.a("進む", :href => v, :class => "button is-primary") }
        end
        tag.div { content.join.html_safe }
      end

      def title
        ""
      end
    end
  end
end
