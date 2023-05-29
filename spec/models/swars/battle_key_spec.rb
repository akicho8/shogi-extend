require "rails_helper"

module Swars
  RSpec.describe BattleKey, type: :model, swars_spec: true do
    let(:key) { "alice-bob-20130531_010024" }
    let(:object) { BattleKey.create(key) }

    describe "ClassMethods" do
      it "[]" do
        assert2 { BattleKey["alice-bob-20130531_010024"].kind_of? BattleKey }
      end

      it "create" do
        assert2 { BattleKey.create("alice-bob-20130531_010024").kind_of? BattleKey }
      end
    end

    describe "InstanceMethods" do
      it "to_s" do
        assert2 { object.to_s == key }
      end

      it "to_battle_url" do
        assert2 { object.to_battle_url == "https://shogiwars.heroz.jp/games/alice-bob-20130531_010024?locale=ja" }
      end

      it "to_time" do
        assert2 { object.to_time == "2013-05-31 01:00:24".to_time }
      end

      it "user_keys" do
        assert2 { object.user_keys == ["alice", "bob"] }
      end

      it "user_key_at" do
        assert2 { object.user_key_at(:black) == "alice" }
      end
    end
  end
end
