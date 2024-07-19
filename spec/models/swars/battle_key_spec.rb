require "rails_helper"

module Swars
  RSpec.describe BattleKey, type: :model, swars_spec: true do
    let(:key) { "alice-bob-20130531_010024" }
    let(:object) { BattleKey.create(key) }

    describe "ClassMethods" do
      it "[]" do
        assert { BattleKey["alice-bob-20130531_010024"].kind_of? BattleKey }
      end

      it "create" do
        assert { BattleKey.create("alice-bob-20130531_010024").kind_of? BattleKey }
      end
    end

    describe "InstanceMethods" do
      it "to_s" do
        assert { object.to_s == key }
      end

      it "official_url" do
        assert { object.official_url == "https://shogiwars.heroz.jp/games/alice-bob-20130531_010024?locale=ja" }
      end

      it "my_url" do
        assert { object.my_url == "http://localhost:4000/swars/battles/alice-bob-20130531_010024" }
      end

      it "to_time" do
        assert { object.to_time == "2013-05-31 01:00:24".to_time }
      end

      it "user_keys" do
        assert { object.user_keys == ["alice", "bob"] }
      end

      it "user_key_at" do
        assert { object.user_key_at(:black) == "alice" }
      end
    end
  end
end
