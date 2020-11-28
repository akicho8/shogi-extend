# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Crawl reservation (swars_crawl_reservations as Swars::CrawlReservation)
#
# |-----------------+-----------------+-------------+-------------+--------------+-------|
# | name            | desc            | type        | opts        | refs         | index |
# |-----------------+-----------------+-------------+-------------+--------------+-------|
# | id              | ID              | integer(8)  | NOT NULL PK |              |       |
# | user_id         | User            | integer(8)  | NOT NULL    | => ::User#id | A     |
# | target_user_key | Target user key | string(255) | NOT NULL    |              |       |
# | to_email        | To email        | string(255) | NOT NULL    |              |       |
# | attachment_mode | Attachment mode | string(255) | NOT NULL    |              | B     |
# | processed_at    | Processed at    | datetime    |             |              |       |
# | created_at      | 作成日時        | datetime    | NOT NULL    |              |       |
# | updated_at      | 更新日時        | datetime    | NOT NULL    |              |       |
# |-----------------+-----------------+-------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

require 'rails_helper'

module Swars
  RSpec.describe CrawlReservation, type: :model do
    before do
      Actb.setup
      Emox.setup
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
      assert { record.to_zip     }

      Zip::InputStream.open(record.to_zip) do |zis|
        entry = zis.get_next_entry
        assert { entry.name == "user1/UTF-8/battle1.kif" }
        assert { NKF.guess(zis.read).to_s == "UTF-8" }

        entry = zis.get_next_entry
        assert { entry.name == "user1/Shift_JIS/battle1.kif" }
        assert { NKF.guess(zis.read).to_s == "Shift_JIS" }
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
