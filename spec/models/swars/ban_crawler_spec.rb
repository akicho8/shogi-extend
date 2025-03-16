require "rails_helper"

RSpec.describe Swars::BanCrawler, type: :model, swars_spec: true do
  it "works" do
    user = Swars::User.create!
    Swars::BanCrawler.new.call
    assert { user.reload.ban? }
  end
end
