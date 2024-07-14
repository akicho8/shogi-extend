require "rails_helper"

module QuickScript
  RSpec.describe FormMod, type: :model do
    it "submitted?" do
      object = Dev::NullScript.new(exec: "true")
      object.params_add_submit_key = :exec
      assert { object.submitted? }
    end
  end
end
