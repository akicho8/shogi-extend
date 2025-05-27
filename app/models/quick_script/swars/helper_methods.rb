module QuickScript
  module Swars
    module HelperMethods
      def header_blank_column(n)
        zero_with_space * n
      end

      def zero_with_space
        "\u200b"
      end
    end
  end
end
