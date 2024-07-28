require "rails_helper"

module QuickScript
  RSpec.describe Dev::DelegateScript, type: :model do
    it "works" do
      assert { Dev::DelegateScript.new.call }
    end
  end
end
