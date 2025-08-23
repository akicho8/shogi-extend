require "rails_helper"

RSpec.describe Ppl::Updater, type: :model do
  it "works" do
    Ppl.setup_for_workbench
    Ppl::Updater.resume_crawling(start: "50", limit: 1)
  end
end
