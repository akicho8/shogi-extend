require "rails_helper"

RSpec.describe Ppl::League, type: :model do
  it "works" do
    Ppl.setup_for_workbench
    Ppl::Updater.update_raw(5, { name: "alice" })
    assert { Ppl::User["alice"].leagues.sole.generation == 5 }
  end
end
