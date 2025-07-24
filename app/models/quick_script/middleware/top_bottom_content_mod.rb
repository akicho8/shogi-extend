module QuickScript
  module Middleware
    concern :TopBottomContentMod do
      def as_json(*)
        super.merge({
            :top_content => top_content,
            :bottom_content => bottom_content,
          })
      end

      def top_content
      end

      def bottom_content
      end
    end
  end
end
