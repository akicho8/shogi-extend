# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Ruleテーブル (fanta_rules as Fanta::Rule)
#
# |------------------+------------------+-------------+-------------+------+-------|
# | カラム名         | 意味             | タイプ      | 属性        | 参照 | INDEX |
# |------------------+------------------+-------------+-------------+------+-------|
# | id               | ID               | integer(8)  | NOT NULL PK |      |       |
# | user_id          | User             | integer(8)  | NOT NULL    |      | A     |
# | lifetime_key     | Lifetime key     | string(255) | NOT NULL    |      | B     |
# | platoon_key      | Platoon key      | string(255) | NOT NULL    |      | C     |
# | self_preset_key  | Self preset key  | string(255) | NOT NULL    |      | D     |
# | oppo_preset_key  | Oppo preset key  | string(255) | NOT NULL    |      | E     |
# | robot_accept_key | Robot accept key | string(255) | NOT NULL    |      | F     |
# | created_at       | 作成日時         | datetime    | NOT NULL    |      |       |
# | updated_at       | 更新日時         | datetime    | NOT NULL    |      |       |
# |------------------+------------------+-------------+-------------+------+-------|

module Fanta
  class Rule < ApplicationRecord
    belongs_to :user

    scope :same_rule_scope, -> e { where(lifetime_key: e.lifetime_key, platoon_key: e.platoon_key) }
    scope :with_robot_ok, -> { where(robot_accept_key: :accept) }     # CPUと対戦してもよい人たち
    scope :with_robot_ng, -> { where(robot_accept_key: :not_accept) } # CPUと対戦したくない人たち

    before_validation on: :create do
      self.self_preset_key  ||= "平手"
      self.oppo_preset_key  ||= "平手"
      self.lifetime_key     ||= :lifetime_m5
      self.platoon_key      ||= :platoon_p1vs1
      self.robot_accept_key ||= "accept"
    end

    with_options allow_blank: true do
      validates :self_preset_key,  inclusion: CustomPresetInfo.keys.collect(&:to_s)
      validates :oppo_preset_key,  inclusion: CustomPresetInfo.keys.collect(&:to_s)
      validates :lifetime_key,     inclusion: LifetimeInfo.keys.collect(&:to_s)
      validates :platoon_key,      inclusion: PlatoonInfo.keys.collect(&:to_s)
      validates :robot_accept_key, inclusion: RobotAcceptInfo.keys.collect(&:to_s)
    end

    def self_preset_info
      CustomPresetInfo.fetch(self_preset_key)
    end

    def oppo_preset_info
      CustomPresetInfo.fetch(oppo_preset_key)
    end

    def lifetime_info
      LifetimeInfo.fetch(lifetime_key)
    end

    def platoon_info
      PlatoonInfo.fetch(platoon_key)
    end

    def robot_accept_info
      RobotAcceptInfo.fetch(robot_accept_key)
    end
  end
end
