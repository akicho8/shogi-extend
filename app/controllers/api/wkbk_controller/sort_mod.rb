module Api
  class WkbkController
    concern :SortMod do
      included do
        include ::SortMod
        include ::PageMod
      end

      def sort_column_default
        :updated_at
      end
    end
  end
end
