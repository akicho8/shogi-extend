module Swars
  module Crawler
    # rails r Swars::Crawler::ReservationCrawler.new.run
    class ReservationCrawler < Base
      def default_params
        super.merge({
            :subject => "棋譜取得の予約者",
          })
      end

      def perform
        CrawlReservation.active_only.find_each do |e|
          report_for(e.target_user_key) do
            e.crawl!(params)
          end
        end
      end
    end
  end
end
