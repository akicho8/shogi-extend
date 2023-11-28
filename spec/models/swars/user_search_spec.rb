require "rails_helper"

module Swars
  RSpec.describe UserSearch, type: :model, swars_spec: true do
    it "ban_only: 垢BANした人としていない人を分けるリレーションが正しい" do
      user = User.create!
      assert { [User.ban_except.count, User.ban_only.count] == [1, 0] }
      user.ban!
      assert { [User.ban_except.count, User.ban_only.count] == [0, 1] }
    end

    it "ban_crawled_count_lteq: 確認回数N回以下を対象とする" do
      user = User.create!
      User.ban_crawled_count_lteq(0) == [user]
      User.ban_crawled_count_lteq(-1) == []
    end

    it "search: すべての検索オプションの条件が正しい" do
      user = User.create!
      assert { User.search == [user] }
      assert { User.search(ids: user.id) == [user] }
      assert { User.search(ids: -1) == [] }
      assert { User.search(grade_keys: user.grade.name) == [user] }
      assert { User.search(grade_keys: "九段") == [] }
      assert { User.search(user_keys: user.key) == [user] }
      assert { User.search(user_keys: "foo") == [] }
      assert { User.search(ban_crawled_count_lteq: 0) == [user] }
      assert { User.search(ban_crawled_count_lteq: -1) == [] }
      assert { User.search(limit: 1) == [user] }
      assert { User.search(limit: 0) == [] }
      assert { User.search(ban_crawled_at_lt: Time.current) == [] }
      assert { User.search(ban_crawled_at_lt: Time.current + 1) == [user] }
      assert { User.search(latest_battled_at_lt: Time.current) == [] }
      assert { User.search(latest_battled_at_lt: Time.current + 1) == [user] }
      assert { User.search(ban_crawl_then_battled: false) == [user] }
      assert { User.search(ban_crawl_then_battled: true) == [] }
    end
  end
end
