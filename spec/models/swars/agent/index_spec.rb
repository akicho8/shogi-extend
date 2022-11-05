require "rails_helper"

module Swars
  module Agent
    RSpec.describe Index, type: :model, swars_spec: true do
      it "development" do
        ary = Index.new(user_key: "kinakom0chi").fetch
        assert { ary.all? { |e| e.include?("YamadaTaro") } }
      end
      it "production" do
        ary = Index.new(user_key: "kinakom0chi", remote_run: true).fetch
        assert { ary.all? { |e| e.include?("kinakom0chi") } }
      end
    end
  end
end
