module QuickScript
  module Chore
    class DocumentationScript < Base
      self.title = "指定のドキュメント表示"
      self.description = "指定のドキュメントを表示する"

      def call
        self.title = markdown_info.title
        self.description = markdown_info.description

        case page_layout
        when :pl_content_with_padding     # navibar がないだけ
          self.navibar_show = false
          component
        when :pl_stripped_content         # いまのところ、どこからも使っていない
          self.main_component = component
        when :pl_default                      # ページまるごと
          component
        else
          raise ArgumentError, page_layout.inspect
        end
      end

      def component
        { _component: "MarkdownContent", _v_bind: { body: markdown_info.markdown_text }, :class => "content" }
      end

      def markdown_info
        MarkdownInfo.fetch(params[:md_key] || :default)
      end

      def page_layout
        (params[:page_layout].presence || :pl_default).to_sym
      end
    end
  end
end
