require "rails_helper"

module QuickScript
  RSpec.describe ProcessTypeMod, type: :model do
    it "works" do
      object = Dev::NullScript.new
      assert { object.axios_process_type == :server }
    end
  end
end
