require "rails_helper"

RSpec.describe Swars::Agent::History, type: :model, swars_spec: true do
  describe "development" do
    it "取得できる" do
      result = Swars::Agent::History.new(user_key: "kinakom0chi").fetch
      assert { result.all_keys.present? }
      assert { result.all_keys.all? { |e| e.user_keys.include?(Swars::UserKey["YamadaTaro"]) } }
    end
    it "game_idを1つづず拾って重複していないこと" do
      result = Swars::Agent::History.new(user_key: "kinakom0chi").fetch
      assert { result.all_keys.uniq == result.all_keys }
    end
  end
  it "production" do
    result = Swars::Agent::History.new(user_key: "abacus10", remote_run: true).fetch
    assert { result.all_keys.present? }
    assert { result.all_keys.all? { |e| e.user_keys.include?(Swars::UserKey["abacus10"]) } }
  end
end
