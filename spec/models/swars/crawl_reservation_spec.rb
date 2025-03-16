# -*- coding: utf-8 -*-
# == Swars::Schema Swars::Information ==
#
# Swars::Crawl reservation (swars_crawl_reservations as Swars::CrawlReservation)
#
# |-----------------+-----------------+-------------+-------------+--------------+-------|
# | name            | desc            | type        | opts        | refs         | index |
# |-----------------+-----------------+-------------+-------------+--------------+-------|
# | id              | ID              | integer(8)  | NOT NULL PK |              |       |
# | user_id         | Swars::User            | integer(8)  | NOT NULL    | => ::User#id | A     |
# | target_user_key | Swars::Target user key | string(255) | NOT NULL    |              |       |
# | to_email        | To email        | string(255) | NOT NULL    |              |       |
# | attachment_mode | Swars::Attachment mode | string(255) | NOT NULL    |              | B     |
# | processed_at    | Swars::Processed at    | datetime    |             |              |       |
# | created_at      | 作成日時        | datetime    | NOT NULL    |              |       |
# | updated_at      | 更新日時        | datetime    | NOT NULL    |              |       |
# |-----------------+-----------------+-------------+-------------+--------------+-------|
#
#- Swars::Remarks ----------------------------------------------------------------------
# Swars::User.has_one :profile
#--------------------------------------------------------------------------------

require "rails_helper"

RSpec.describe Swars::CrawlReservation, type: :model, swars_spec: true do
  it "works" do
    current_user = ::User.admin
    swars_user = Swars::User.create!
    battle = Swars::Battle.create! do |e|
      e.memberships.build(user: swars_user)
    end

    record = current_user.swars_crawl_reservations.create!({
        :attachment_mode => "with_zip",
        :target_user_key => swars_user.key,
      })

    record.crawl!
    record.reload
    assert { record.processed_at }

    assert { record.to_zip }

    Zip::InputStream.open(record.to_zip) do |zis|
      entry = zis.get_next_entry
      assert { entry.name == "user1/UTF-8/alice-bob-20000101_000000.kif" }
      assert { NKF.guess(zis.read).to_s == "UTF-8" }

      entry = zis.get_next_entry
      assert { entry.name == "user1/Shift_JIS/alice-bob-20000101_000000.kif" }
      assert { NKF.guess(zis.read).to_s == "Shift_JIS" }
    end
  end
end
