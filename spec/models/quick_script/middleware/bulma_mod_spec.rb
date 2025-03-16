require "rails_helper"

RSpec.describe QuickScript::Middleware::BulmaMod, type: :model do
  it "works" do
    object = QuickScript::Dev::NullScript.new
    assert { object.bulma_messsage("(subject)", "(body)") }
  end
end
