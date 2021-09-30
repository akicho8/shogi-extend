require "rails_helper"

RSpec.describe User, type: :model do
  include ActbSupportMethods

  it "works" do
    assert { notification1 }
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 1.54 seconds (files took 2.27 seconds to load)
# >> 1 example, 0 failures
# >> 
