require "rails_helper"

module QuickScript
  module Swars
    RSpec.describe ProScript, type: :model do
      it "works" do
        assert { ProScript.new.as_json[:redirect_to] }
      end
    end
  end
end
