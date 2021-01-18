require 'rails_helper'

module Wbook
  RSpec.describe UserMod::OUcountNotifyMod, type: :model do
    include WbookSupportMethods

    it "works" do
      assert { user1.o_ucount_notify_once }
      Wbook::LobbyMessage.last.body # => "<a href=\"/training?user_id=14\">user1</a>さんが本日0問解きました"
      assert { Wbook::LobbyMessage.last.body.match?(/本日/) }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 1.43 seconds (files took 2.19 seconds to load)
# >> 1 example, 0 failures
# >> 
