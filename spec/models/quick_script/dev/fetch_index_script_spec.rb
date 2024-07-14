require "rails_helper"

module QuickScript
  RSpec.describe Dev::FetchIndexScript, type: :model do
    it "works" do
      assert { Dev::FetchIndexScript.new.as_json }
    end
  end
end
