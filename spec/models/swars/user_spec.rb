require "rails_helper"

module Swars
  RSpec.describe User, type: :model, swars_spec: true do
    it "ユーザー名は大小文字を区別する" do
      User.create!(key: "ALICE")
      assert2 { User.new(key: "alice").valid? }
    end

    describe "垢BAN" do
      it "ban!: 垢BANすると二箇所の user.ban_at と profile.ban_at をセットする" do
        user = User.create!
        user.ban!
        user.reload
        user.profile.reload
        
        assert2 { user.ban_at }
        assert2 { user.profile.ban_at }
        assert2 { user.profile.ban_crowled_at }
        assert2 { user.profile.ban_crowl_count == 1 }
      end

      it "ban_only: 垢BANした人としていない人を分けるリレーションが正しい" do
        user = User.create!
        assert2 { [User.ban_except.count, User.ban_only.count] == [1, 0] }
        user.ban!
        assert2 { [User.ban_except.count, User.ban_only.count] == [0, 1] }
      end

      it "ban_crowl_count_lteq: 確認回数N回以下を対象とする" do
        user = User.create!
        User.ban_crowl_count_lteq(0) == [user]
        User.ban_crowl_count_lteq(-1) == []
      end

      it "ban_reset: 垢BANも確認もしていない状態に戻す" do
        user = User.create!
        user.ban!
        user.ban_reset
        user.reload
        assert2 { user.ban_at == nil }
        assert2 { user.profile.ban_at == nil }
        assert2 { user.profile.ban_crowl_count == 0 }
        assert2 { user.profile.ban_crowled_at }
      end

      it "ban_crawl_scope: 垢BANクロール対象を求める" do
        user = User.create!
        assert2 { User.ban_crawl_scope == [user] }
        assert2 { User.ban_crawl_scope(grade_keys: user.grade.name) == [user] }
        assert2 { User.ban_crawl_scope(grade_keys: "九段") == [] }
        assert2 { User.ban_crawl_scope(user_keys: user.key) == [user] }
        assert2 { User.ban_crawl_scope(user_keys: "foo") == [] }
        assert2 { User.ban_crawl_scope(ban_crowl_count_lteq: 0) == [user] }
        assert2 { User.ban_crawl_scope(ban_crowl_count_lteq: -1) == [] }
        assert2 { User.ban_crawl_scope(limit: 1) == [user] }
        assert2 { User.ban_crawl_scope(limit: 0) == [] }
        assert2 { User.ban_crawl_scope(ban_crowled_at_lt: Time.current) == [] }
        assert2 { User.ban_crawl_scope(ban_crowled_at_lt: Time.current + 1) == [user] }
      end
    end
  end
end
