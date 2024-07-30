module QuickScript
  module Chore
    class DocumentationScript < Base
      class_attribute :md_key, default: :default

      class << self
        def markdown_info
          MarkdownInfo.fetch(md_key)
        end

        def title
          markdown_info.title
        end

        def description
          markdown_info.description
        end
      end

      def call
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
        MarkdownInfo.lookup(params[:md_key]) || self.class.markdown_info
      end

      def page_layout
        (params[:page_layout].presence || :pl_default).to_sym
      end

      def title
        markdown_info.title
      end

      def description
        markdown_info.description
      end
    end
  end
end
