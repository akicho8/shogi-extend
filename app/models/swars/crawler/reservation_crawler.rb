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
          key = record.target_user_key
          report_for(key) do
            other_options = battle_count_diff_block(key) do
              Importer::UserImporter.new(params.merge(user_key: key)).run
            end
            record.update!(processed_at: Time.current)
            UserMailer.battle_fetch_notify(record, other_options).deliver_later
          end
        end
      end

      private

      def battle_count_diff_block(key)
        user = User.find_by(key: key)
        before_count = 0
        after_count = 0
        if user
          before_count = user.battles.count
        end
        yield
        if user
          after_count = user.battles.count
        end
        {
          :before_count => before_count,
          :after_count  => after_count,
          :diff_count   => after_count - before_count,
        }
      end
    end
  end
end
