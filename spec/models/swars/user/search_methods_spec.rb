require "rails_helper"

RSpec.describe Swars::User::SearchMethods, type: :model, swars_spec: true do
  it "ban_only: 垢BANした人としていない人を分けるリレーションが正しい" do
    user = Swars::User.create!
    assert { [Swars::User.ban_except.count, Swars::User.ban_only.count] == [1, 0] }
    user.ban!
    assert { [Swars::User.ban_except.count, Swars::User.ban_only.count] == [0, 1] }
  end

  it "ban_crawled_count_lteq: 確認回数X回以下を対象とする" do
    user = Swars::User.create!
    Swars::User.ban_crawled_count_lteq(0) == [user]
    Swars::User.ban_crawled_count_lteq(-1) == []
  end

  it "search: すべての検索オプションの条件が正しい" do
    user = Swars::User.create!
    assert { Swars::User.search == [user] }
    assert { Swars::User.search(ids: user.id) == [user] }
    assert { Swars::User.search(ids: -1) == [] }
    assert { Swars::User.search(grade_keys: user.grade.name) == [user] }
    assert { Swars::User.search(grade_keys: "九段") == [] }
    assert { Swars::User.search(user_keys: user.key) == [user] }
    assert { Swars::User.search(user_keys: "foo") == [] }
    assert { Swars::User.search(ban_crawled_count_lteq: 0) == [user] }
    assert { Swars::User.search(ban_crawled_count_lteq: -1) == [] }
    assert { Swars::User.search(limit: 1) == [user] }
    assert { Swars::User.search(limit: 0) == [] }
    assert { Swars::User.search(ban_crawled_at_lt: Time.current) == [] }
    assert { Swars::User.search(ban_crawled_at_lt: Time.current + 1) == [user] }
    assert { Swars::User.search(latest_battled_at_lt: Time.current) == [] }
    assert { Swars::User.search(latest_battled_at_lt: Time.current + 1) == [user] }
    assert { Swars::User.search(ban_crawl_then_battled: false) == [user] }
    assert { Swars::User.search(ban_crawl_then_battled: true) == [] }
  end
end
