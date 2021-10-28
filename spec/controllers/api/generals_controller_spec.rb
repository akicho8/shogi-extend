require "rails_helper"

RSpec.describe Api::GeneralsController, type: :controller do
  describe "any_source_to" do
    def test1(method, to_format)
      send(method, :any_source_to, params: { any_source: "68銀", to_format: to_format, format: "json" })
      JSON.parse(response.body, symbolize_names: true)
    end

    describe "GETもPOSTも対応" do
      it "works" do
        result = { body: "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7i6h", turn_max: 1 }
        assert { test1(:get, :sfen)  == result }
        assert { test1(:post, :sfen) == result }
      end
    end

    describe "KI2はcandidate_enableが有効が必須" do
      it do
        assert { test1(:post, :ki2)[:body].include?("▲６八銀") }
      end
    end

    describe "その他のフォーマット" do
      it do
        assert { test1(:post, :csa)[:body].include?("+7968GI") }
        assert { test1(:post, :kif)[:body].include?("嬉野流") }
      end
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> ...
# >> 
# >> Finished in 2.87 seconds (files took 4.88 seconds to load)
# >> 3 examples, 0 failures
# >> 
