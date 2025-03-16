require "rails_helper"

RSpec.describe Swars::Crawler::ReserveUserCrawler, type: :model do
  it "works" do
    current_user = ::User.admin
    swars_user = Swars::User.create!
    Swars::Battle.create! do |e|
      e.memberships.build(user: swars_user)
    end
    Swars::CrawlReservation.destroy_all

    current_user.swars_crawl_reservations.create!(target_user_key: swars_user.key)
    assert { Swars::CrawlReservation.active_only.count == 1 }
    Swars::Crawler::ReserveUserCrawler.new.call
    assert { Swars::CrawlReservation.active_only.count == 0 }
  end
end
