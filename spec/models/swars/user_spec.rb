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
        assert2 { user.profile.ban_crawled_at }
        assert2 { user.profile.ban_crawled_count == 1 }
      end

      it "ban_reset: 垢BANも確認もしていない状態に戻す" do
        user = User.create!
        user.ban!
        user.ban_reset
        user.reload
        assert2 { user.ban_at == nil }
        assert2 { user.profile.ban_at == nil }
        assert2 { user.profile.ban_crawled_count == 0 }
        assert2 { user.profile.ban_crawled_at }
      end
    end
  end
end
