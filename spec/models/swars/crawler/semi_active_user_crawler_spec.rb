require "rails_helper"

module Swars
  RSpec.describe Crawler::SemiActiveUserCrawler, type: :model do
    it "works" do
      user = User.create!
      user.search_logs.create!
      instance = Crawler::SemiActiveUserCrawler.new(period: 0, at_least: 1, hard_crawled_old: -1.seconds)
      assert { Battle.none? }
      instance.call
      assert { Battle.exists? }
      assert { instance.mail_body }
    end
  end
end
