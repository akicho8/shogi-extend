require 'rails_helper'

RSpec.describe ExternalAppInfo, type: :model do
  describe "external_url" do
    let(:swars_record) { Swars::Battle.create! }
    let(:free_record)  { FreeBattle.create!    }

    it "piyo_shogi" do
      assert { ExternalAppInfo[:piyo_shogi].external_url(swars_record) == "piyoshogi://?num=5&url=http://0.0.0.0:3000/w/battle1.kif"      }
      assert { ExternalAppInfo[:piyo_shogi].external_url(free_record)  == "piyoshogi://?num=5&url=http://0.0.0.0:3000/x/free_battle1.kif" }
    end

    it "kento" do
      assert { ExternalAppInfo[:kento].external_url(swars_record)      == "https://www.kento-shogi.com/?initpos=lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL+b+-+1&moves=7i6h.8b3b.5g5f.3c3d.6h5g#5" }
      assert { ExternalAppInfo[:kento].external_url(free_record)       == "https://www.kento-shogi.com/?initpos=lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL+b+-+1&moves=7i6h.8b3b.5g5f.3c3d.6h5g#5" }
    end
  end

  it "apple_touch_icon" do
    ExternalAppInfo.each(&:apple_touch_icon)
  end
end
