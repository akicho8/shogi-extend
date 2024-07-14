require "rails_helper"

module QuickScript
  RSpec.describe AutoexecMod, type: :model do
    it "works" do
      object = QuickScript::Dev::NullScript.new
      assert { object.as_json.has_key?(:fetch_then_auto_exec_action) }
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> QuickScript::AutoexecMod
# >>   works
# >> 
# >> Top 1 slowest examples (0.09675 seconds, 5.1% of total time):
# >>   QuickScript::AutoexecMod works
# >>     0.09675 seconds -:5
# >> 
# >> Finished in 1.9 seconds (files took 1.38 seconds to load)
# >> 1 example, 0 failures
# >> 
