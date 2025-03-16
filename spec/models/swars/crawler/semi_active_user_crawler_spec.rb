require "rails_helper"

RSpec.describe Swars::Crawler::SemiActiveUserCrawler, type: :model do
  it "works" do
    user = Swars::User.create!
    user.search_logs.create!
    instance = Swars::Crawler::SemiActiveUserCrawler.new(period: 0, at_least: 1, hard_crawled_old: -1.seconds)
    assert { Swars::Battle.none? }
    instance.call
    assert { Swars::Battle.exists? }
    assert { instance.mail_body }
  end
end
