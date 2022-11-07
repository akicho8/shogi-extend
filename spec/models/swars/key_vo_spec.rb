require "rails_helper"

module Swars
  RSpec.describe KeyVo, type: :model, swars_spec: true do
    let(:key) { "alice-bob-20130531_010024" }
    let(:object) { KeyVo.wrap(key) }

    describe "ClassMethods" do
      it "[]" do
        assert { KeyVo["alice-bob-20130531_010024"].kind_of? KeyVo }
      end

      it "wrap" do
        assert { KeyVo.wrap("alice-bob-20130531_010024").kind_of? KeyVo }
      end

      it "valid?" do
        assert { KeyVo.valid?("alice-bob-20130531_010024") }
      end

      it "invalid?" do
        assert { KeyVo.invalid?("xxx") }
      end

      it "generate" do
        assert { KeyVo.generate.kind_of? KeyVo }
      end
    end

    describe "InstanceMethods" do
      it "to_s" do
        assert { object.to_s == key }
      end

      it "originator_url" do
        assert { object.originator_url == "https://shogiwars.heroz.jp/games/alice-bob-20130531_010024?locale=ja" }
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

      it "valid?" do
        assert { KeyVo.new(key).valid? }
      end

      it "invalid?" do
        assert { KeyVo.new("xxx").invalid? }
      end

      it "validate!" do
        expect { KeyVo.wrap("xxx") }.to raise_error(ArgumentError)
      end
    end
  end
end
