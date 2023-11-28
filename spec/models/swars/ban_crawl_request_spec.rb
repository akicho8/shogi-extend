require "rails_helper"

module Swars
  RSpec.describe BanCrawlRequest, type: :model, swars_spec: true do
    it "リレーションが正しい" do
      user = User.create!
      ban_crawl_request = user.ban_crawl_requests.create!
      assert { ban_crawl_request.user == user }
      assert { user.ban_crawl_requests == [ban_crawl_request] }
    end
  end
end
