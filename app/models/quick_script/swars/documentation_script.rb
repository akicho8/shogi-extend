module QuickScript
  module Swars
    class DocumentationScript < Chore::DocumentationScript
      CURRENT = MarkdownInfo.fetch(:swars_search)

      self.title = CURRENT.title
      self.description = CURRENT.description

      def initialize(...)
        super
        params[:md_key] = CURRENT.key
      end
    end
  end
end
