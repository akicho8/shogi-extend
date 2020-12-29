require 'rails_helper'

module TsMaster
  RSpec.describe Stock, type: :model do
    it "setup" do
      Stock.setup(reset: true, mate: [3, 5], max: 1)
      assert { Stock.mate_eq(3).count == 1 }
      assert { Stock.mate_eq(5).count == 1 }
    end

    it "sample" do
      Stock.setup(reset: true, mate: 3, max: 1)
      error = Stock.sample(mate: 3, max: 2) rescue $!           # => #<RuntimeError: 3手詰問題を2件取得したかったが1件足りない
      assert { error.message.include?("3手詰問題を2件取得したかったが1件足りない") }

      Stock.setup(reset: true, mate: 3, max: 10)
      srand(0)
      assert { Stock.sample(mate: 3, max: 5).collect(&:position) == [5, 0, 3, 7, 9] }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> ..
# >> 
# >> Finished in 0.35902 seconds (files took 2.39 seconds to load)
# >> 2 examples, 0 failures
# >> 
