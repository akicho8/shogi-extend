require "rails_helper"

RSpec.describe Swars::TagFrequency, type: :model, swars_spec: true do
  it "as_json" do
    Swars::Battle.create!
    json = Swars::TagFrequency.new.as_json
    assert { json[:attack]["新嬉野流"] }
  end
end
