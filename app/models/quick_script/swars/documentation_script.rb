module QuickScript
  module Swars
    class DocumentationScript < Chore::DocumentationScript
      self.title = MarkdownInfo[:swars_search].title

      def initialize(...)
        super
        params[:md_key] = :swars_search
      end
    end
  end
end
