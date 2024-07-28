require "rails_helper"

module QuickScript
  RSpec.describe Middleware::BulmaMod, type: :model do
    it "works" do
      object = QuickScript::Dev::NullScript.new
      assert { object.bulma_messsage("(subject)", "(body)") }
    end
  end
end
