require "rails_helper"

module Swars
  module Agent
    RSpec.describe Index, type: :model, swars_spec: true do
      it "development" do
        result = Index.new(user_key: "kinakom0chi").fetch
        assert { result.keys.present? }
        assert { result.keys.all? { |e| e.include?("YamadaTaro") } }
      end
      it "production" do
        result = Index.new(user_key: "kinakom0chi", remote_run: true).fetch
        assert { result.keys.present? }
        assert { result.keys.all? { |e| e.include?("kinakom0chi") } }
      end
    end
  end
end
