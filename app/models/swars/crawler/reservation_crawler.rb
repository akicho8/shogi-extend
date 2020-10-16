module Swars
  module Crawler
    # rails r Swars::Crawler::ReservationCrawler.new.run
    class ReservationCrawler < Base
      def default_params
        {
          page_max: (Rails.env.production? || Rails.env.staging?) ? 256 : 1,
        }
      end

      def perform
        s = CrawlReservation.where(processed_at: nil)
        s.each do |record|
          user_key = record.user.key
          report_for(user_key) do
            Battle.user_import(params.merge(user_key: user_key))
            record.update!(processed_at: Time.current)
            UserMailer.battle_fetch_notify(record).deliver_later
          end
        end
      end
    end
  end
end
