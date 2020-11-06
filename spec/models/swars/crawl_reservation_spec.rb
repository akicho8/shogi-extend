require 'rails_helper'

module Swars
  RSpec.describe CrawlReservation, type: :model do
    before do
      Actb.setup
      Swars.setup
    end

    let :login_user do
      ::User.create!
    end

    let :battle do
      Battle.create!
    end

    let :battle_user do
      battle.users.first
    end

    it do
      record = login_user.swars_crawl_reservations.create!({
          :attachment_mode => "with_zip",
          :target_user_key => battle_user.key,
        })

      assert { record.persisted? }
      assert { record.zip_io     }

      Zip::InputStream.open(record.zip_io) do |zis|
        entry = zis.get_next_entry
        assert { entry.name == "utf8/battle1.kif" }
        assert { NKF.guess(zis.read) == Encoding::UTF_8 }

        entry = zis.get_next_entry
        assert { entry.name == "sjis/battle1.kif" }
        assert { NKF.guess(zis.read) == Encoding::Shift_JIS }
      end
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 1.75 seconds (files took 2.21 seconds to load)
# >> 1 example, 0 failures
# >> 
