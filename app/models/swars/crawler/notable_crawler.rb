module Swars
  module Crawler
    # Swars::Crawler::NotableCrawler.new(look_up_to_page_x: 3, sleep: 5).call
    class NotableCrawler < Base
      def default_params
        super.merge({
            :user_keys => default_user_keys,
            :look_up_to_page_x  => Rails.env.production? ? 100 : 1,
            :subject   => "活動的なプレイヤー",
          })
      end

      def perform
        params[:user_keys].each do |user_key|
          report_for(user_key) do
            Importer::FullHistoryImporter.new(params.merge(user_key: user_key)).call
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
