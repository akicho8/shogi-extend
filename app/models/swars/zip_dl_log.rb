# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Zip dl log (swars_zip_dl_logs as Swars::ZipDlLog)
#
# |---------------+------------+-------------+-------------+---------------------+-------|
# | name          | desc       | type        | opts        | refs                | index |
# |---------------+------------+-------------+-------------+---------------------+-------|
# | id            | ID         | integer(8)  | NOT NULL PK |                     |       |
# | user_id       | User       | integer(8)  | NOT NULL    | => ::User#id        | A     |
# | swars_user_id | Swars user | integer(8)  | NOT NULL    | => ::Swars::User#id | B     |
# | query         | Query      | string(255) | NOT NULL    |                     |       |
# | dl_count      | Dl count   | integer(4)  | NOT NULL    |                     |       |
# | begin_at      | Begin at   | datetime    | NOT NULL    |                     |       |
# | end_at        | End at     | datetime    | NOT NULL    |                     | C     |
# | created_at    | 作成日時   | datetime    | NOT NULL    |                     | D     |
# | updated_at    | 更新日時   | datetime    | NOT NULL    |                     |       |
# |---------------+------------+-------------+-------------+---------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
# 【警告:リレーション欠如】::Swars::Userモデルで has_many :swars/zip_dl_logs されていません
#--------------------------------------------------------------------------------

# rails r 'tp Swars::ZipDlLog'

module Swars
  class ZipDlLog < ApplicationRecord
    belongs_to :user,       class_name: "::User"        # ダウンロードしようとしている人
    belongs_to :swars_user, class_name: "::Swars::User" # ダウンロードされようとしている人

    with_options presence: true do
      validates :begin_at
      validates :end_at
    end
  end
end
