require "rails_helper"

module QuickScript
  module About
    RSpec.describe TermsScript, type: :model do
      it "works" do
        assert { TermsScript.new.as_json }
      end
    end
  end
end
