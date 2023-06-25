require "rails_helper"

module Swars
  RSpec.describe Battle, type: :model, swars_spec: true do
    it "works" do
      assert2 { Battle.stat }
    end
  end
end
