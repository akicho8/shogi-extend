require "rails_helper"

RSpec.describe Api::GeneralsController, type: :controller do
  describe "any_source_to" do
    def test(method)
      send(method, :any_source_to, params: { any_source: "68銀", to_format: "sfen" })
      value = JSON.parse(response.body, symbolize_names: true)
      assert { value == { body: "position startpos moves 7i6h", turn_max: 1} }
    end
    it do
      test(:get)
      test(:post)
    end
  end
end
