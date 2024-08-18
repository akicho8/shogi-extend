require "rails_helper"

module QuickScript
  module Swars
    RSpec.describe TacticHistogramScript, type: :model do
      it "works" do
        assert { TacticHistogramScript.new({tactic_key: :attack}).as_json }
        assert { TacticHistogramScript.new({tactic_key: :note}).as_json }
      end
    end
  end
end
