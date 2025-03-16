require "rails_helper"

RSpec.describe Tsl::NameNormalizer, type: :model do
  it "works" do
    assert { Tsl::NameNormalizer.normalize("小髙") == "小高" }
  end
end
