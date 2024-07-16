require "rails_helper"

module QuickScript
  RSpec.describe Chore::NotFoundScript, type: :model do
    it "works" do
      assert { Chore::NotFoundScript.new.as_json }
    end
  end
end
