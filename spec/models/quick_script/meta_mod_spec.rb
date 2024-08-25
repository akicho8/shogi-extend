require "rails_helper"

module QuickScript
  RSpec.describe MetaMod, type: :model do
    it "works" do
      object = Dev::NullScript.new
      assert { object.as_json[:meta] }
    end

    it "og_image_key_default" do
      assert { Dev::NullScript.og_image_key_default == :application }
      assert { Chore::NullScript.og_image_key_default == "quick_script/chore/null_script" }
    end
  end
end
