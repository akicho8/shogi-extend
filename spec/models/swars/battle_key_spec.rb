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
        assert { object.official_url == "https://shogiwars.heroz.jp/games/alice-bob-20130531_010024" }
      end

      it "inside_show_url" do
        assert { object.inside_show_url == "http://localhost:4000/swars/battles/alice-bob-20130531_010024" }
      end

      it "kento_url" do
        assert { object.kento_url == "http://localhost:4000/swars/battles/alice-bob-20130531_010024/kento" }
      end

      it "piyo_shogi_url" do
        assert { object.piyo_shogi_url == "http://localhost:4000/swars/battles/alice-bob-20130531_010024/piyo_shogi" }
      end

      it "to_time" do
        assert { object.to_time == "2013-05-31 01:00:24".to_time }
      end

      it "user_keys" do
        assert { object.user_keys == ["alice", "bob"] }
      end

      it "user_key_at" do
        assert { object.user_key_at(:white) == "bob" }
      end
    end
  end
end
