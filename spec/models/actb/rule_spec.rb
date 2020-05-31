require 'rails_helper'

module Actb
  RSpec.describe Rule, type: :model do
    include ActbSupportMethods

    it do
      Actb::Rule.all.collect(&:key) # => ["marathon_rule", "singleton_rule", "hybrid_rule"]
      assert { Rule.all.count >= 1 }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >>
# >> Finished in 0.32605 seconds (files took 2.15 seconds to load)
# >> 1 example, 0 failures
# >>
