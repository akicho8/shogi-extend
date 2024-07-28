require "rails_helper"

module Swars
  RSpec.describe Crawler::ReservationCrawler, type: :model do
    it "works" do
      current_user = ::User.admin
      sw_user = User.create!
      Battle.create! do |e|
        e.memberships.build(user: sw_user)
      end
      CrawlReservation.destroy_all

      current_user.swars_crawl_reservations.create!(target_user_key: sw_user.key)
      assert { CrawlReservation.active_only.count == 1 }
      Crawler::ReservationCrawler.new.run
      assert { CrawlReservation.active_only.count == 0 }
    end
  end
end
