require "rails_helper"

RSpec.describe Swars::Crawler::MainActiveUserCrawler, type: :model do
  it "works" do
    user = Swars::User.create!
    instance = Swars::Crawler::MainActiveUserCrawler.new(user_keys: [user.key])
    assert { Swars::User["YamadaTaro"] == nil }
    instance.call
    assert { Swars::User["YamadaTaro"].battles.count >= 1 }
    assert { instance.mail_body }
  end
end
