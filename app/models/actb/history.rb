# -*- coding: utf-8 -*-
# == Schema Information ==
#
# History (actb_histories as Actb::History)
#
# |---------------+------------+------------+-------------+------------------------------+-------|
# | name          | desc       | type       | opts        | refs                         | index |
# |---------------+------------+------------+-------------+------------------------------+-------|
# | id            | ID         | integer(8) | NOT NULL PK |                              |       |
# | user_id       | User       | integer(8) | NOT NULL    | => ::User#id                 | A     |
# | question_id   | Question   | integer(8) | NOT NULL    |                              | B     |
# | created_at    | 作成日時   | datetime   | NOT NULL    |                              |       |
# | updated_at    | 更新日時   | datetime   | NOT NULL    |                              |       |
# | room_id       | Room       | integer(8) | NOT NULL    |                              | C     |
# | battle_id     | Battle     | integer(8) | NOT NULL    |                              | D     |
# | membership_id | Membership | integer(8) | NOT NULL    | => Actb::BattleMembership#id | E     |
# | ox_mark_id    | Ox mark    | integer(8) | NOT NULL    |                              | F     |
# | rating        | Rating     | integer(4) | NOT NULL    |                              |       |
# |---------------+------------+------------+-------------+------------------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_many :actb_room_messages
# 【警告:リレーション欠如】Actb::BattleMembershipモデルで has_many :actb/histories されていません
#--------------------------------------------------------------------------------

module Actb
  class History < ApplicationRecord
    include ClipMark::ShareWithHistoryMethods # belongs_to user and question

    belongs_to :ox_mark

    # この3つは使ってない？
    # → user, question, membership で find するため membership は必要
    # room, battle はなくてもいい
    belongs_to :room
    belongs_to :battle
    belongs_to :membership, class_name: "Actb::BattleMembership"

    before_validation do
      if membership
        self.battle ||= membership.battle
      end

      if battle
        self.room ||= battle.room
      end

      # 調査用
      if user
        self.rating ||= user.rating
      end

      self.ox_mark ||= OxMark.fetch(:mistake)
    end
  end
end
