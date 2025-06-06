require "rails_helper"

RSpec.describe Kento::Url, type: :model do
  it "works" do
    assert { Kento::Url["https://example.com/"].to_sfen == "position startpos" }
    assert { Kento::Url["https://example.com/?moves=7g7f.3c3d"].to_sfen == "position startpos moves 7g7f 3c3d" }

    url = "https://example.com/?initpos=lnsgkgsnl%2F9%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%201&moves=7a6b.7g7f"
    assert { Kento::Url[url].to_sfen == "position sfen lnsgkgsnl/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 moves 7a6b 7g7f" }

    url = "https://example.com/?branch=6i7h.8c8d&branchFrom=2&moves=3i4h.3c3d.5g5f"
    assert { Kento::Url[url].to_sfen == "position startpos moves 3i4h 3c3d 6i7h 8c8d" }

    url = "https://example.com/?initpos=7gk%2F9%2F7GG%2F7N1%2F9%2F9%2F2s3%2Bp%2Bp%2Bp%2F6%2Bp2%2F6%2Bp1K%20b%2013p4l3n3sg2b2r%201#0"
    assert { Kento::Url[url].to_sfen == "position sfen 7gk/9/7GG/7N1/9/9/2s3+p+p+p/6+p2/6+p1K b 13p4l3n3sg2b2r 1" }

    url = "https://example.com/?branch=N%2A7e.7d7e.B%2A7d.8c9c.G%2A9b.9a9b.7d9b%2B.9c9b.6c7b.R%2A8b.G%2A8c.9b9a.7b8b.7c8b.R%2A9b&branchFrom=0&initpos=ln7%2F2g6%2F1ks%2BR5%2Fpppp5%2F9%2F9%2F%2Bp%2Bp%2Bp6%2F2%2Bp6%2FK1%2Bp6%20b%20NGB9p3l2n3s2gbr%201#6"
    assert { Kento::Url[url].to_sfen == "position sfen ln7/2g6/1ks+R5/pppp5/9/9/+p+p+p6/2+p6/K1+p6 b NGB9p3l2n3s2gbr 1" }
  end

  it "attributes" do
    url = "https://example.com/?branch=N%2A7e.7d7e.B%2A7d.8c9c.G%2A9b.9a9b.7d9b%2B.9c9b.6c7b.R%2A8b.G%2A8c.9b9a.7b8b.7c8b.R%2A9b&branchFrom=0&initpos=ln7%2F2g6%2F1ks%2BR5%2Fpppp5%2F9%2F9%2F%2Bp%2Bp%2Bp6%2F2%2Bp6%2FK1%2Bp6%20b%20NGB9p3l2n3s2gbr%201#6"
    object = Kento::Url[url]
    assert { object.attributes }
  end
end
