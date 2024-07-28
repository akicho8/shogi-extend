require "rails_helper"

module QuickScript
  RSpec.describe Middleware::PrimaryErrorMessageMod, type: :model do
    it "works" do
      object = Dev::NullScript.new
      object.primary_error_message = SecureRandom.hex
      assert { object.as_json[:primary_error_message] }
      assert { object.meta[:primary_error_message] }
    end
  end
end
