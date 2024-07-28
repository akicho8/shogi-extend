module QuickScript
  module Dev
    class MarkdownScript < Base
      self.title = "Markdown表示"
      self.description = "markdown を JS 側の marked を使って変換表示する"

      def call
        { _component: "MarkdownContent", _v_bind: { body: "# 見出し" }, :class => "content" }
      end
    end
  end
end
