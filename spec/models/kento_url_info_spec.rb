require 'rails_helper'

RSpec.describe KentoUrlInfo, type: :model do
  it do
    assert { KentoUrlInfo.parse("https://www.kento-shogi.com/?initpos=lnsgkgsnl%2F9%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%201&moves=7a6b.7g7f").to_sfen == "position sfen lnsgkgsnl/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 moves 7a6b 7g7f" }
    assert { KentoUrlInfo.parse("https://www.kento-shogi.com/?branch=6i7h.8c8d&branchFrom=2&moves=3i4h.3c3d.5g5f").to_sfen                                                        == "position startpos moves 3i4h 3c3d 6i7h 8c8d" }
    assert { KentoUrlInfo.parse("https://www.kento-shogi.com/?moves=7g7f.3c3d").to_sfen                                                                                           == "position startpos moves 7g7f 3c3d" }
    assert { KentoUrlInfo.parse("https://www.kento-shogi.com/").to_sfen                                                                                                           == "position startpos" }
    assert { KentoUrlInfo.parse("https://www.kento-shogi.com/?initpos=7gk%2F9%2F7GG%2F7N1%2F9%2F9%2F2s3%2Bp%2Bp%2Bp%2F6%2Bp2%2F6%2Bp1K%20b%2013p4l3n3sg2b2r%201#0").to_sfen       == "position sfen 7gk/9/7GG/7N1/9/9/2s3+p+p+p/6+p2/6+p1K b 13p4l3n3sg2b2r 1" }
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.32553 seconds (files took 7.68 seconds to load)
# >> 1 example, 0 failures
# >> 
