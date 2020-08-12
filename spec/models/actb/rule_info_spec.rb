require 'rails_helper'

module Actb
  RSpec.describe RuleInfo, type: :model do
    include ActbSupportMethods

    before do
      question1
    end

    it "works" do
      RuleInfo.each do |rule_info|
        assert { rule_info.generate }
      end
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 1.45 seconds (files took 2.33 seconds to load)
# >> 1 example, 0 failures
# >> 
