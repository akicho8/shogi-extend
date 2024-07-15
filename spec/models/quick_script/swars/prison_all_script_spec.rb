require "rails_helper"

module QuickScript
  module Swars
    RSpec.describe  PrisonAllScript, type: :model do
      it "works" do
        ::Swars::User.create!(key: "alice").ban!
        ::Swars::User.create!(key: "bob").ban!
        assert { PrisonAllScript.new.call[:_v_text] == "alice bob" }
      end
    end
  end
end
