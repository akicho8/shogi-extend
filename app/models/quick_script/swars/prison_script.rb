module QuickScript
  module Swars
    class PrisonScript < Base
      self.title = "囚人"

      def call
        records = ::Swars::User.ban_only.page(params[:page]).per(3)
        @page_params[:paginated] = true
        @page_params[:total] = records.total_pages
        @page_params[:current_page] = (params[:page] || 1).to_i
        @page_params[:per_page] = 3
        records
      end
    end
  end
end
