require "rails_helper"

RSpec.describe type: :model do
  # test 環境で Rails.cache が効いていないためテストできない
  xit "works" do
    throttle = Throttle.new(expires_in: 0.1)
    throttle.call { true }
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> {:type=>:model}
# >>   works (PENDING: Temporarily skipped with xit)
# >> 
# >> Pending: (Failures listed here are expected and do not affect your suite's status)
# >> 
# >>   1) {:type=>:model} works
# >>      # Temporarily skipped with xit
# >>      # -:5
# >> 
# >> Top 1 slowest examples (0.00001 seconds, 0.0% of total time):
# >>   {:type=>:model} works
# >>     0.00001 seconds -:5
# >> 
# >> Finished in 2.01 seconds (files took 3.4 seconds to load)
# >> 1 example, 0 failures, 1 pending
# >> 
