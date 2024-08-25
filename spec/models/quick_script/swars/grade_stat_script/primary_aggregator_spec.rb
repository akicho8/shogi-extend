require "rails_helper"

module QuickScript
  module Swars
    class GradeStatScript
      RSpec.describe PrimaryAggregator, type: :model do
        it "works" do
          PrimaryAggregator.mock_setup
          assert { PrimaryAggregator.new.call[:population_count] == 2 }
        end
      end
    end
  end
end
