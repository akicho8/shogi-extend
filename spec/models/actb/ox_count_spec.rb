require 'rails_helper'

module Actb
  RSpec.describe OxCount, type: :model do
    include ActbSupportMethods

    it "ox_add" do
      question1.ox_add(:o_count)
      question1.ox_add(:o_count)
      question1.ox_add(:x_count)
      ox_count = question1.ox_count

      assert { ox_count.o_count  == 2       }
      assert { ox_count.x_count  == 1       }
      assert { ox_count.ox_total == 3       }
      assert { ox_count.o_rate   == 0.66667 }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.81795 seconds (files took 2.21 seconds to load)
# >> 1 example, 0 failures
# >> 
