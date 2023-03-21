require "rails_helper"

RSpec.describe BasenameNormalizer, type: :model do
  it "works" do
    is_asserted_by { BasenameNormalizer.normalize("/_ _/(A 漢 あ ア .).mp3").to_s == "/_ _/A漢あア.mp3" }
  end
end
