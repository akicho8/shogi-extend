module Swars
  module Crawler
    # rails r Swars::Crawler::ReservationCrawler.new.run
    class ReservationCrawler < Base
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
