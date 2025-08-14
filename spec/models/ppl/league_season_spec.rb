require "rails_helper"

RSpec.describe Ppl::LeagueSeason, type: :model do
  it "works" do
    Ppl.setup_for_workbench
    Ppl::Updater.update_raw(5, { name: "alice" })
    assert { Ppl::User["alice"].league_seasons.sole.season_number == 5 }
  end
end
