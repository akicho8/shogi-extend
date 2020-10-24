require "rails_helper"

RSpec.describe Api::GeneralsController, type: :controller do
  describe "any_source_to" do
    def test(method)
      send(method, :any_source_to, params: { any_source: "68銀", to_format: "sfen", format: "json" })
      value = JSON.parse(response.body, symbolize_names: true)
      assert { value == { body: "position startpos moves 7i6h", turn_max: 1} }
    end

    it "works" do
      test(:get)
      test(:post)
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> ..
# >> 
# >> Finished in 0.57695 seconds (files took 2.2 seconds to load)
# >> 2 examples, 0 failures
# >> 
