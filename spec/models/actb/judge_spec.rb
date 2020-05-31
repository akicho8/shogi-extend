require 'rails_helper'

module Actb
  RSpec.describe Judge, type: :model do
    include ActbSupportMethods

    it do
      Actb::Judge.all.collect(&:key) # => ["win", "lose", "draw", "pending"]
      assert { Judge.all.count >= 1 }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.21287 seconds (files took 2.14 seconds to load)
# >> 1 example, 0 failures
# >> 
