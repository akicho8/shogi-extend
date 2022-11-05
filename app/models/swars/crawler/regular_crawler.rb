module Swars
  module Crawler
    # Swars::Crawler::RegularCrawler.new.run
    class RegularCrawler < Base
      def default_params
        {
          limit: (Rails.env.production? || Rails.env.staging?) ? 10 : 1,
          page_max: (Rails.env.production? || Rails.env.staging?) ? 256 : 3,
          early_break: true,
        }
      end

      def perform
        User.regular_only.limit(params[:limit]).each do |user|
          report_for(user.key) do
            Importer::AllRuleImporter.new(params.merge(user_key: user.key)).run
          end
        end
      end
    end
  end
end
