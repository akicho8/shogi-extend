require 'rails_helper'

module Emox
  RSpec.describe RuleInfo, type: :model do
    include EmoxSupportMethods

    it "works" do
      assert { RuleInfo.as_json }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 1.46 seconds (files took 2.17 seconds to load)
# >> 1 example, 0 failures
# >> 
