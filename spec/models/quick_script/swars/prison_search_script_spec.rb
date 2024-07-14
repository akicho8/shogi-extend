require "rails_helper"

module QuickScript
  module Swars
    RSpec.describe  PrisonSearchScript, type: :model do
      it "works" do
        user = ::Swars::User.create!
        user.ban!
        response = PrisonSearchScript.new.as_json
        assert { response[:body][:rows].size == 1 }
      end
    end
  end
end
