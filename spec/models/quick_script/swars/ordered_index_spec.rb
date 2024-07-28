require "rails_helper"

module QuickScript
  module Swars
    RSpec.describe OrderedIndex, type: :model do
      it "works" do
        assert { OrderedIndex.size == 8 }
      end
    end
  end
end
