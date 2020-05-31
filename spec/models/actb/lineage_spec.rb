require 'rails_helper'

module Actb
  RSpec.describe Lineage, type: :model do
    include ActbSupportMethods

    it do
      Actb::Lineage.all.collect(&:key) # => ["詰将棋", "実戦詰め筋", "手筋", "必死", "必死逃れ", "定跡", "秘密"]
      assert { Lineage.all.count >= 1 }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.33905 seconds (files took 2.26 seconds to load)
# >> 1 example, 0 failures
# >> 
