require 'rails_helper'

module Actb
  RSpec.describe Final, type: :model do
    include ActbSupportMethods

    it do
      Actb::Final.all.collect(&:key) # => ["f_give_up", "f_disconnect", "f_success", "f_pending"]
      assert { Final.all.count >= 1 }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.34602 seconds (files took 2.16 seconds to load)
# >> 1 example, 0 failures
# >> 
