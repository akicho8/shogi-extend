require 'rails_helper'

module Actb
  RSpec.describe Room, type: :model do
    include ActbSupportMethods

    it "バトル生成" do
      assert { room1.battle_create_with_members!.kind_of?(Actb::Battle) }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.69169 seconds (files took 2.2 seconds to load)
# >> 1 example, 0 failures
# >> 
