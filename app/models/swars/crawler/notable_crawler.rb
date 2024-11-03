module Swars
  module Crawler
    # Swars::Crawler::NotableCrawler.new(page_max: 3, sleep: 5).run
    class NotableCrawler < Base
      def default_params
        super.merge({
            :user_keys   => default_user_keys,
            :page_max    => Rails.env.production? ? 100 : 1,
            :early_break => false,
            :subject     => "活動的なプレイヤー",
          })
      end

      def perform
        params[:user_keys].each do |user_key|
          report_for(user_key) do
            Importer::AllRuleImporter.new(params.merge(user_key: user_key)).run
          end
        end
      end

      private

      def default_user_keys
        case
        when Rails.env.production?
          Swars::User::Vip.auto_crawl_user_keys
        when Rails.env.staging?
          ["itoshinTV", "BOUYATETSU5", "bsplive"]
        else
          ["DevUser1"]
        end
      end
    end
  end
end
