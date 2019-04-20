module Swars
  module Crawler
    # Swars::Crawler::RegularCrawler.new.run
    class RegularCrawler < Base
      def default_params
        {
          limit: Rails.env.production? ? 32 : 1,
          sleep: Rails.env.production? ? 4 : 0,
          page_max: Rails.env.production? ? 256 : 3,
        }
      end

      def perform
        User.regular_only.limit(params[:limit]).each do |user|
          difference_report_for(user.user_key) do
            Battle.user_import(params.merge(user_key: user.user_key))
          end
        end
      end
    end
  end
end
