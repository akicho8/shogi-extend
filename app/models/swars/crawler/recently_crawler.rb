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
          report_for(user.key) do
            Importer::AllRuleImporter.new(params.merge(user_key: user.key)).run
          end
        end
      end
    end
  end
end
