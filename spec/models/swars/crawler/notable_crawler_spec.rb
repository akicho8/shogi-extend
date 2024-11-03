require "rails_helper"

module Swars
  RSpec.describe Crawler::NotableCrawler, type: :model do
    it "works" do
      user = User.create!
      instance = Crawler::NotableCrawler.new(user_keys: [user.key])
      assert { User["YamadaTaro"] == nil }
      instance.run
      assert { User["YamadaTaro"].battles.count >= 1 }
      assert { instance.mail_body }
    end
  end
end
