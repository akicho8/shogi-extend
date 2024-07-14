require "rails_helper"

module QuickScript
  module Swars
    RSpec.describe UserScript, type: :model do
      it "works" do
        assert { UserScript.new.as_json }
      end
    end
  end
end
