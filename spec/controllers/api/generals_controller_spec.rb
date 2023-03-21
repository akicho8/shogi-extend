require "rails_helper"

RSpec.describe Api::GeneralsController, type: :controller do
  describe "any_source_to" do
    def case1(method, to_format, any_source)
      send(method, :any_source_to, params: { any_source: any_source, to_format: to_format, format: "json" })
      JSON.parse(response.body, symbolize_names: true)
    end

    describe "デバッグ用にGETでも受け付ける" do
      it "works" do
        is_asserted_by { case1(:get, :sfen, "68銀")[:turn_max]  }
      end
    end

    it "各種フォーマットに変換する" do
      is_asserted_by { case1(:post, :sfen, "68銀")[:body].include?("7i6h")          }
      is_asserted_by { case1(:post, :csa, "68銀")[:body].include?("+7968GI")        }
      is_asserted_by { case1(:post, :kif, "68銀")[:body].include?("嬉野流")         }
      is_asserted_by { case1(:post, :ki2, "58金(49)")[:body].include?("▲５八金右") }
    end
  end
end
