require "rails_helper"

# module CacheTestHelper
#   def with_cache
#     Rails.cache.clear
#     Rails.application.configure do
#       config.action_controller.perform_caching = true
#       config.cache_store = :redis_cache_store, { db: AppConfig.fetch(:redis_db_for_rails_cache) }
#     end
#
#     Rails.cache.clear
#     yield
#   ensure
#     Rails.application.configure do
#       config.action_controller.perform_caching = false
#       config.cache_store = :null_store
#     end
#     Rails.cache.clear
#   end
# end

RSpec.describe type: :model do
  # include CacheTestHelper

  # test 環境で Rails.cache が効いていないためテストできない
  xit "works" do
    with_cache do
      throttle = Throttle.new(expires_in: 0.1)
      throttle.reset
      assert { throttle.call { true } == true  }
      assert { throttle.call { true } == false }
      sleep(0.1)
      assert { throttle.call { true } == true  }
      assert { throttle.call { true } == false }
    end
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
