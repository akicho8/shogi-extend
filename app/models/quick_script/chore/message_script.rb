module QuickScript
  module Chore
    class MessageScript < Base
      self.title = "メッセージ表示"
      self.description = "引数のメッセージを表示する"
      self.login_link_show = true

      def call
        content = []
        if v = params[:message]
          content << h.simple_format(v, :class => "block")
        end
        if v = params[:return_to]
          content << tag.p(:class => "block") { tag.a("進む", :href => v, :class => "button is-primary") }
        end
        if content.present?
          tag.div { content.join.html_safe }
        end
      end

      def title
        ""
      end
    end
  end
end
