require "rails_helper"

RSpec.describe QuickScript::ModelStat, type: :model do
  it "works" do
    capture(:stdout) { QuickScript::ModelStat.new.call }
  end
end
