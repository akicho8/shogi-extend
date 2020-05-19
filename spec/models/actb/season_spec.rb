require 'rails_helper'

module Actb
  RSpec.describe Season, type: :model do
    let_it_be :user do
      Colosseum::User.create!
    end

    it "単に新しいレコードを作るだけでユーザーの新シーズンに切り替わる" do
      assert { Season.newest.generation                   == 1 }
      assert { user.actb_newest_profile.season.generation == 1 }
      assert { Season.create!.generation                  == 2 }
      assert { user.actb_newest_profile.season.generation == 2 }
    end

    it "このシーズンを持っている profiles" do
      assert { Season.newest.profiles }
    end
  end
end
