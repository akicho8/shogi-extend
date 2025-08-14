require "rails_helper"

RSpec.describe Ppl::Updater, type: :model do
  it "works" do
    Ppl.setup_for_workbench
    Ppl::Updater.resume_crawling(season_numbers: [50])
  end
end
