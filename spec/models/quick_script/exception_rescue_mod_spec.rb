require "rails_helper"

module QuickScript
  RSpec.describe ExceptionRescueMod, type: :model do
    it "works" do
      proc { Dev::ErrorScript.new.call }.should raise_error(ZeroDivisionError)
      assert { Dev::ErrorScript.new.as_json }
    end
  end
end
