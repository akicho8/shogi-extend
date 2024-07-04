require "rails_helper"

RSpec.describe type: :model do
  # test 環境で Rails.cache が効いていないためテストできない
  xit "works" do
    throttle = Throttle.new(expires_in: 0.1)
    throttle.run { true }
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> {:type=>:model}
# >>   works (FAILED - 1)
# >>
# >> Failures:
# >>
# >>   1) {:type=>:model} works
# >>      Failure/Error: @redis ||= Rails.cache.redis.with(&:itself)
# >>
# >>      NoMethodError:
# >>        undefined method `redis' for #<ActiveSupport::Cache::NullStore options={:compress=>true, :compress_threshold=>1024}>
# >>      # ./app/models/throttle.rb:78:in `redis'
# >>      # ./app/models/throttle.rb:41:in `run'
# >>      # ./app/models/throttle.rb:32:in `run'
# >>      # -:7:in `block (2 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:26:in `block (3 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:26:in `block (2 levels) in <main>'
# >>
# >> Top 1 slowest examples (0.00052 seconds, 0.0% of total time):
# >>   {:type=>:model} works
# >>     0.00052 seconds -:5
# >>
# >> Finished in 2.16 seconds (files took 2.05 seconds to load)
# >> 1 example, 1 failure
# >>
# >> Failed examples:
# >>
# >> rspec -:5 # {:type=>:model} works
# >>
