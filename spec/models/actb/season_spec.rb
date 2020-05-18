require 'rails_helper'

module Actb
  RSpec.describe Season, type: :model do
    let_it_be :user do
      Colosseum::User.create!
    end

    it do
      assert { Season.newest.generation                   == 1 }
      assert { user.actb_newest_profile.season.generation == 1 }
      assert { Season.create!.generation                  == 2 }
      assert { user.actb_newest_profile.season.generation == 2 }
    end
  end
end
