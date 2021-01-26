module Api
  module Wkbk
    class ApplicationController < ::Api::ApplicationController
      include SortMod
      include PageMod

      def sort_column_default
        :updated_at
      end
    end
  end
end
