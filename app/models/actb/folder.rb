# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Folder (actb_folders as Actb::Folder)
#
# |------------+------------+-------------+-------------+--------------------+-------|
# | name       | desc       | type        | opts        | refs               | index |
# |------------+------------+-------------+-------------+--------------------+-------|
# | id         | ID         | integer(8)  | NOT NULL PK |                    |       |
# | user_id    | User       | integer(8)  | NOT NULL    | => User#id         | A! B  |
# | type       | 所属モデル | string(255) | NOT NULL    | SpecificModel(STI) | A!    |
# | created_at | 作成日時   | datetime    | NOT NULL    |                    |       |
# | updated_at | 更新日時   | datetime    | NOT NULL    |                    |       |
# |------------+------------+-------------+-------------+--------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

module Actb
  class Folder < ApplicationRecord
    belongs_to :user # FIXME: 設計ミス。ユーザー毎のフォルダを持つ必要がない

    has_many :questions, dependent: :destroy

    delegate :name, :type, to: :pure_info

    def pure_info
      FolderInfo.fetch(key)
    end

    # :active, :draft, :trash
    def key
      @key ||= self.class.name.demodulize.underscore.remove("_box").to_sym
    end
  end
end
