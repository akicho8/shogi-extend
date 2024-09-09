require "rails_helper"

module QuickScript
  RSpec.describe Swars::CrossSearchScript, type: :model do
    it "works" do
      battle = ::Swars::Battle.create!(csa_seq: ::Swars::KifuGenerator.ibis_pattern)
      instance = Swars::CrossSearchScript.new(tag: "居飛車", _method: "post")
      assert { instance.all_ids == [battle.id] }
      assert { instance.as_json }
      assert { Swars::CrossSearchScript.new(tag: "振り飛車", _method: "post").all_ids == [] }
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> QuickScript::Swars::CrossSearchScript
# >>   works
# >> 
# >> Top 1 slowest examples (0.52559 seconds, 19.3% of total time):
# >>   QuickScript::Swars::CrossSearchScript works
# >>     0.52559 seconds -:5
# >> 
# >> Finished in 2.72 seconds (files took 2.27 seconds to load)
# >> 1 example, 0 failures
# >> 
