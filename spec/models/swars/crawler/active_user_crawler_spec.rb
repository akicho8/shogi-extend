require "rails_helper"

module Swars
  RSpec.describe Crawler::ActiveUserCrawler, type: :model do
    it "works" do
      user = User.create!
      instance = Crawler::ActiveUserCrawler.new(user_keys: [user.key])
      assert { User["YamadaTaro"] == nil }
      instance.call
      assert { User["YamadaTaro"].battles.count >= 1 }
      assert { instance.mail_body }
    end
  end
end
