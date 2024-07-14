require "rails_helper"

module QuickScript
  module Swars
    RSpec.describe  PrisonAllScript, type: :model do
      it "works" do
        assert { PrisonAllScript.new.as_json }
      end
    end
  end
end
