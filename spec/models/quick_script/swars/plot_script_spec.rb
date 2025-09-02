require "rails_helper"

RSpec.describe QuickScript::Swars::PlotScript, type: :model do
  it "works" do
    assert { QuickScript::Swars::PlotScript.new.call }
  end
end
