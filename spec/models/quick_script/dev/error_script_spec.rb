require "rails_helper"

module QuickScript
  RSpec.describe Dev::ErrorScript, type: :model do
    it "works" do
      proc { Dev::ErrorScript.new.call }.should raise_error(ZeroDivisionError)
      assert { Dev::ErrorScript.new(__EXCEPTION_RESCUE__: true).as_json }
    end
  end
end
