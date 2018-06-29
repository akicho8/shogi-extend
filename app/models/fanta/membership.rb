# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 対局と対局者の対応テーブル (fanta_memberships as Fanta::Membership)
#
# |--------------+--------------+-------------+-------------+------+-------|
# | カラム名     | 意味         | タイプ      | 属性        | 参照 | INDEX |
# |--------------+--------------+-------------+-------------+------+-------|
# | id           | ID           | integer(8)  | NOT NULL PK |      |       |
# | battle_id    | Battle       | integer(8)  | NOT NULL    |      | A     |
# | user_id      | User         | integer(8)  | NOT NULL    |      | B     |
# | preset_key   | Preset key   | string(255) | NOT NULL    |      |       |
# | location_key | Location key | string(255) | NOT NULL    |      | C     |
# | position     | 順序         | integer(4)  |             |      | D     |
# | standby_at   | Standby at   | datetime    |             |      |       |
# | fighting_at  | Fighting at  | datetime    |             |      |       |
# | time_up_at   | Time up at   | datetime    |             |      |       |
# | created_at   | 作成日時     | datetime    | NOT NULL    |      |       |
# | updated_at   | 更新日時     | datetime    | NOT NULL    |      |       |
# |--------------+--------------+-------------+-------------+------+-------|

module Fanta
  class Membership < ApplicationRecord
    belongs_to :battle
    belongs_to :user

    scope :black, -> { where(location_key: "black") }
    scope :white, -> { where(location_key: "white") }

    scope :active, -> { where.not(location_key: nil) }       # 対局者
    scope :standby_enable, -> { where.not(standby_at: nil) } # 準備ができている

    acts_as_list top_of_list: 0, scope: :battle

    default_scope { order(:position) }

    before_validation on: :create do
      # active = battle.memberships.active
      # if active.count < Warabi::Location.count
      #   if membership = active.first
      #     location = membership.location
      #   else
      #     location = Warabi::Location[Battle.count.modulo(Warabi::Location.count)]
      #   end
      #   self.location_key ||= location.flip.key
      # end

      # create!(users: [user1, user2]) とされた場合を考慮する
      # index = battle.users.find_index(user) || battle.users.count
      # self.location_key ||= Warabi::Location.fetch(index).key
      self.location_key ||= Warabi::Location.fetch(battle.users.count).key

      # if active.count < Warabi::Location.count
      # if membership = active.first
      #   location = membership.location
      # else
      #   location = Warabi::Location[Battle.count.modulo(Warabi::Location.count)]
      # end
      # self.location_key ||= Warabi::Location[active.count.modulo(Warabi::Location.count)].key

      if user
        self.preset_key ||= user.self_preset_key
      end
      self.preset_key ||= "平手"
    end

    after_save do
      if saved_changes[:fighting_at]
        user.update!(fighting_at: fighting_at)
      end
    end

    # before_validation do
    #   if location_key == "watching"
    #     self.location_key = nil
    #   end
    # end

    with_options presence: true do
      # validates :location_key
    end

    with_options allow_blank: true do
      validates :location_key, inclusion: Warabi::Location.keys.collect(&:to_s)
    end

    def location
      Warabi::Location[location_key]
    end

    def location_flip!
      if location
        update!(location_key: location.flip.key)
      end
    end
  end
end
