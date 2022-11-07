require "rails_helper"

module Swars
  module Agent
    RSpec.describe History, type: :model, swars_spec: true do
      it "development" do
        result = History.new(user_key: "kinakom0chi").fetch
        assert { result.all_keys.present? }
        assert { result.all_keys.all? { |e| e.user_keys.include?("YamadaTaro") } }
      end
      it "production" do
        result = History.new(user_key: "kinakom0chi", remote_run: true).fetch
        assert { result.all_keys.present? }
        assert { result.all_keys.all? { |e| e.user_keys.include?("kinakom0chi") } }
      end
    end
  end
end
