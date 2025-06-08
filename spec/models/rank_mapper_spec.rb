require "rails_helper"

RSpec.describe RankMapper, type: :model do
  it "works" do
    assert { RankMapper.ranks([])                       == [] }
    assert { RankMapper.ranks([nil, 1]) rescue $!.class == ArgumentError }
    assert { RankMapper.ranks([5, 5])                   == [0, 0] }
    assert { RankMapper.ranks([7, 6, 6, 5, 5])          == [4, 2, 2, 0, 0] }
    assert { RankMapper.ranks([2, 3, 4], base_rank: 5)  == [5, 6, 7] }
    assert { RankMapper.ranks([-5, -4, -4, -3])         == [0, 1, 1, 3] }
  end
end
