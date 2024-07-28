require "rails_helper"

module QuickScript
  module About
    RSpec.describe CreditScript, type: :model do
      it "works" do
        assert { CreditScript.new.as_json }
      end
    end
  end
end
