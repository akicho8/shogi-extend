require 'rails_helper'

module Actb
  RSpec.describe Folder, type: :model do
    include ActbSupportMethods

    it do
      question1
      assert { user1.actb_active_box.questions.count >= 1 }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.73437 seconds (files took 2.19 seconds to load)
# >> 1 example, 0 failures
# >> 
