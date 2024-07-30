require "rails_helper"

module QuickScript
  module Swars
    RSpec.describe SearchScript, type: :model do
      it "works" do
        assert { SearchScript.new.as_json }
      end
    end
  end
end
