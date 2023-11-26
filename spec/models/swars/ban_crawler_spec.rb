require "rails_helper"

module Swars
  RSpec.describe BanCrawler, type: :model, swars_spec: true do
    it "works" do
      user = User.create!
      Swars::BanCrawler.new.call
      assert2 { user.reload.ban? }
    end
  end
end
