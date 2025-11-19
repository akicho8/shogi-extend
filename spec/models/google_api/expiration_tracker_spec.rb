# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Expiration tracker (google_api_expiration_trackers as GoogleApi::ExpirationTracker)
#
# |----------------+-------------+-------------+-------------+------+-------|
# | name           | desc        | type        | opts        | refs | index |
# |----------------+-------------+-------------+-------------+------+-------|
# | id             | ID          | integer(8)  | NOT NULL PK |      |       |
# | spreadsheet_id | Spreadsheet | string(255) | NOT NULL    |      |       |
# | created_at     | 作成日時    | datetime    | NOT NULL    |      |       |
# | updated_at     | 更新日時    | datetime    | NOT NULL    |      |       |
# |----------------+-------------+-------------+-------------+------+-------|
#
# - Remarks ----------------------------------------------------------------------
# [Warning: Need to add index] create_google_api_expiration_trackers マイグレーションに add_index :google_api_expiration_trackers, :spreadsheet_id を追加しよう
# [Warning: Need to add relation] GoogleApi::ExpirationTracker モデルに belongs_to :spreadsheet を追加しよう
# --------------------------------------------------------------------------------

require "rails_helper"

RSpec.describe GoogleApi::ExpirationTracker, type: :model do
  before do
    Timecop.return do
      GoogleApi::ExpirationTracker.destroy_all
    end
  end

  after do
    Timecop.return do
      GoogleApi::ExpirationTracker.destroy_all
    end
  end

  it "プレッドシートを作ったあとで削除する" do
    Timecop.return do
      GoogleApi::Facade.new(rows: [{ id: 1 }]).call
      assert { GoogleApi::ExpirationTracker.count == 1 }
    end
  end
end
