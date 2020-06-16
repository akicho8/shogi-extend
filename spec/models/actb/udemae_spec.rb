require 'rails_helper'

module Actb
  RSpec.describe Battle, type: :model do
    include ActbSupportMethods

    def test1(udemae_key, udemae_point, diff)
      user1.actb_master_xrecord.update!(udemae: Udemae.fetch(udemae_key), udemae_point: udemae_point)
      user1.actb_master_xrecord.udemae_point_add(diff)
      [user1.udemae.key, user1.udemae_point]
    end

    it do
      # 上昇
      assert { test1("C-",  98, 1)   == ["C-", 99] }
      assert { test1("C-",  98, 2)   == ["C",   0] }
      assert { test1("C-",  98, 3)   == ["C",   1] }
      # 上昇(飛び級)
      assert { test1("C-",  98, 101) == ["C",  99] }
      assert { test1("C-",  98, 102) == ["C+",  0] }
      assert { test1("C-",  98, 103) == ["C+",  1] }
      # 下降
      assert { test1("C+",  2, -1)   == ["C+",  1] }
      assert { test1("C+",  2, -2)   == ["C+",  0] }
      assert { test1("C+",  2, -3)   == ["C",  99] }
      # 下降(飛び級)
      assert { test1("C+",  2, -101) == ["C",   1] }
      assert { test1("C+",  2, -102) == ["C",   0] }
      assert { test1("C+",  2, -103) == ["C-", 99] }
      # 限界(上)
      assert { test1("S+", 98, 1)    == ["S+", 99] }
      assert { test1("S+", 98, 2)    == ["S+", 99] }
      assert { test1("S+", 98, 3)    == ["S+", 99] }
      # 限界(下)
      assert { test1("C-",  2, -1)   == ["C-",  1] }
      assert { test1("C-",  2, -2)   == ["C-",  0] }
      assert { test1("C-",  2, -3)   == ["C-",  0] }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.97033 seconds (files took 2.53 seconds to load)
# >> 1 example, 0 failures
# >> 
