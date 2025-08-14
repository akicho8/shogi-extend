require "rails_helper"

RSpec.describe Ppl::Updater, type: :model do
  it "works" do
    Ppl.setup_for_workbench
    Ppl::Updater.resume_crawling(generations: [50])
  end
end
