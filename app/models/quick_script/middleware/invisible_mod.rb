module QuickScript
  module Middleware
    concern :InvisibleMod do
      prepended do
        class_attribute :qs_invisible, default: false # true: 一覧 (IndexScript) で見えなくなる
      end

      class_methods do
        def title_for_index
          if qs_invisible
            return "*#{super}*"
          end

          super
        end
      end
    end
  end
end
