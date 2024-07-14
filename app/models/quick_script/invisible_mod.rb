module QuickScript
  concern :InvisibleMod do
    prepended do
      class_attribute :qs_invisible, default: false
    end

    class_methods do
      def short_title
        if qs_invisible
          return "*#{super}*"
        end

        super
      end
    end
  end
end
