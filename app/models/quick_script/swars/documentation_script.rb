module QuickScript
  module Swars
    class DocumentationScript < Base
      self.title = "よくある質問(FAQ)"

      def call
        { _component: "MarkdownContent", _v_bind: { body: markdown_text }, :class => "content" }
      end

      def markdown_text
        Pathname(__dir__).join("../articles/swars_search.md").read
      end
    end
  end
end
