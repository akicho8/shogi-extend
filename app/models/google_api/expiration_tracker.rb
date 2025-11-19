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

module GoogleApi
  class ExpirationTracker < ApplicationRecord
    scope :old_only, -> expires_in { where(arel_table[:created_at].lteq(expires_in.seconds.ago)) }

    with_options presence: true do
      validates :spreadsheet_id
    end

    def spreadsheet_delete
      GoogleApi::Toolkit.new.dispatch(:spreadsheet_delete, spreadsheet_id)
    end

    # def destroy_for_general_cleaner
    #   spreadsheet_delete and destroy!
    # end

    after_destroy :spreadsheet_delete
  end
end
