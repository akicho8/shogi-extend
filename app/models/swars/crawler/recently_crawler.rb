module Swars
  module Crawler
    # Swars::Crawler::RecentlyCrawler.run
    class RecentlyCrawler < Base
      private

      def default_params
        {
          limit: (Rails.env.production? || Rails.env.staging?) ? 10 : 1,
          page_max: (Rails.env.production? || Rails.env.staging?) ? 256 : 3,
          early_break: true,
        }
      end

      def perform
        User.recently_only.limit(params[:limit]).each do |user|
          report_for(user.user_key) do
            Battle.user_import(params.merge(user_key: user.user_key))
          end
        end
      end
    end
  end
end
