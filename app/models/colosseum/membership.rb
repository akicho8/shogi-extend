# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 対局と対局者の対応 (colosseum_memberships as Colosseum::Membership)
#
# |--------------+----------------------------------------+-------------+-------------+------+-------|
# | name         | desc                                   | type        | opts        | refs | index |
# |--------------+----------------------------------------+-------------+-------------+------+-------|
# | id           | ID                                     | integer(8)  | NOT NULL PK |      |       |
# | battle_id    | 部屋ID                                 | integer(8)  | NOT NULL    |      | A     |
# | user_id      | ユーザーID                             | integer(8)  | NOT NULL    |      | B     |
# | preset_key   | 手合割                                 | string(255) | NOT NULL    |      |       |
# | location_key | 先後                                   | string(255) | NOT NULL    |      | C     |
# | position     | 入室順序                               | integer(4)  |             |      | D     |
# | standby_at   | 準備完了日時                           | datetime    |             |      |       |
# | fighting_at  | 部屋に入った日時で抜けたり切断すると空 | datetime    |             |      |       |
# | time_up_at   | タイムアップしたのを検知した日時       | datetime    |             |      |       |
# | created_at   | 作成日時                               | datetime    | NOT NULL    |      |       |
# | updated_at   | 更新日時                               | datetime    | NOT NULL    |      |       |
# |--------------+----------------------------------------+-------------+-------------+------+-------|

module Colosseum
  class Membership < ApplicationRecord
    belongs_to :battle, counter_cache: true
    belongs_to :user

    scope :location_eq, -> e { where(location_key: e) }

    scope :black, -> { location_eq(:black) }
    scope :white, -> { location_eq(:white) }

    scope :standby_enable, -> { where.not(standby_at: nil) } # 準備ができている

    default_scope { order(:position) }

    acts_as_list top_of_list: 0, scope: :battle

    before_validation on: :create do
      self.location_key ||= Bioshogi::Location.fetch(battle.users.count).key

      if user
        self.preset_key ||= user.self_preset_info.key
      end
      self.preset_key ||= "平手"
    end

    with_options allow_blank: true do
      validates :location_key, inclusion: Bioshogi::Location.keys.collect(&:to_s)
    end

    after_save do
      if saved_changes[:fighting_at]
        user.update!(fighting_at: fighting_at) # これはいるかな？
      end
    end

    after_commit do
      ActionCable.server.broadcast(battle.channel_key, memberships: ams_sr(battle.reload.memberships))
    end

    def location
      Bioshogi::Location[location_key]
    end
  end
end
