require "rails_helper"

module QuickScript
  module General
    RSpec.describe EncyclopediaScript, type: :model do
      it "works" do
        assert { EncyclopediaScript.new(tag: "棒銀").as_json }
      end
    end
  end
end
