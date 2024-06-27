require "rails_helper"

module Swars
  RSpec.describe TagFrequency, type: :model, swars_spec: true do
    it "as_json" do
      Battle.create!
      json = TagFrequency.new.as_json
      assert { json["居飛車"] }
    end
  end
end
