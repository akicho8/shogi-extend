require "rails_helper"

module Swars
  RSpec.describe Crawler::MomentumCrawler, type: :model do
    it "works" do
      user = User.create!
      user.search_logs.create!
      instance = Crawler::MomentumCrawler.new(period: 0, at_least: 1)
      assert { Battle.none? }
      instance.run
      assert { Battle.exists? }
      assert { instance.mail_body }
    end
  end
end
