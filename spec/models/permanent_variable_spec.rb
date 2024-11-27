require "rails_helper"

RSpec.describe PermanentVariable, type: :model, swars_spec: true do
  it "works" do
    PermanentVariable.destroy_all

    assert { PermanentVariable["A"] == nil }

    PermanentVariable["A"] = "x"
    assert { PermanentVariable["A"] == "x" }

    PermanentVariable["A"] = {"x" => 1}
    assert { PermanentVariable["A"] == { x: 1 } }
  end
end
