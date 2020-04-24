require "rails_helper"

RSpec.describe Api::GeneralsController, type: :controller do
  describe "any_source_to_sfen" do
    before do
      get :any_source_to_sfen, params: { any_source: "68銀" }
    end
    let(:value) do
      JSON.parse(response.body, symbolize_names: true)
    end
    it do
      assert { value == {sfen: "position startpos moves 7i6h", turn_max: 1} }
    end
  end
end
