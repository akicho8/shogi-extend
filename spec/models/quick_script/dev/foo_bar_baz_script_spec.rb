require "rails_helper"

module QuickScript
  RSpec.describe Dev::FooBarBazScript, type: :model do
    it "works" do
      assert { Dev::FooBarBazScript.new.as_json }
    end
  end
end
