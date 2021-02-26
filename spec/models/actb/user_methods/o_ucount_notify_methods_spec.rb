require 'rails_helper'

module Actb
  RSpec.describe UserMethods::OUcountNotifyMethods, type: :model do
    include ActbSupportMethods

    it "works" do
      assert { user1.o_ucount_notify_once }
      Actb::LobbyMessage.last.body # => "<a href=\"/training?user_id=14\">user1</a>さんが本日0問解きました"
      assert { Actb::LobbyMessage.last.body.match?(/本日/) }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 1.43 seconds (files took 2.19 seconds to load)
# >> 1 example, 0 failures
# >> 
