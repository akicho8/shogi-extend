require "rails_helper"

module QuickScript
  RSpec.describe Dev::FormValueSessionRestoreScript, type: :model do
    it "works" do
      assert { Dev::FormValueSessionRestoreScript.new.as_json }
    end
  end
end
