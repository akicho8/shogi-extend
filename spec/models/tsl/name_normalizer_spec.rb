require "rails_helper"

module Tsl
  RSpec.describe NameNormalizer, type: :model do
    it "works" do
      is_asserted_by { NameNormalizer.normalize("小髙") == "小高" }
    end
  end
end
