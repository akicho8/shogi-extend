module QuickScript
  module Middleware
    concern :HeadMod do
      def as_json(*)
        super.merge({
            :head_content => head_content,
          })
      end

      def head_content
      end
    end
  end
end
