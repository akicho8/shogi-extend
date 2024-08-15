require "rails_helper"

module Swars
  module Agent
    RSpec.describe History, type: :model, swars_spec: true do
      describe "development" do
        it "取得できる" do
          result = History.new(user_key: "kinakom0chi").fetch
          assert { result.all_keys.present? }
          assert { result.all_keys.all? { |e| e.user_keys.include?(UserKey["YamadaTaro"]) } }
        end
        it "game_idを1つづず拾って重複していないこと" do
          result = History.new(user_key: "kinakom0chi").fetch
          assert { result.all_keys.uniq == result.all_keys }
        end
      end
      it "production" do
        result = History.new(user_key: "chrono_", remote_run: true).fetch
        assert { result.all_keys.present? }
        assert { result.all_keys.all? { |e| e.user_keys.include?(UserKey["chrono_"]) } }
      end
    end
  end
end

