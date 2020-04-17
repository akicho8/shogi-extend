require 'rails_helper'

module Acns2
  RSpec.describe EloRating, type: :model do
    it do
      assert { EloRating.rating_update(1500, 1500) == [1516, 1484] }
      assert { EloRating.rating_update(1500, 1800) == [1527, 1773] }
      assert { EloRating.rating_update(1500, 1000) == [1502, 998]  }
    end
  end
end
