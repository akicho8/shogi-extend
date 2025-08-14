require "rails_helper"

RSpec.describe Ppl::NameNormalizer, type: :model do
  it "works" do
    assert { Ppl::NameNormalizer.normalize("小髙") == "小高" }
  end
end
