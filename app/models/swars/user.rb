# -*- coding: utf-8 -*-
# == Schema Information ==
#
# User (swars_users as Swars::User)
#
# |-------------------+-------------------+-------------+-------------+------+-------|
# | name              | desc              | type        | opts        | refs | index |
# |-------------------+-------------------+-------------+-------------+------+-------|
# | id                | ID                | integer(8)  | NOT NULL PK |      |       |
# | user_key          | User key          | string(255) | NOT NULL    |      | A!    |
# | grade_id          | Grade             | integer(8)  | NOT NULL    |      | B     |
# | last_reception_at | Last reception at | datetime    |             |      |       |
# | search_logs_count | Search logs count | integer(4)  | DEFAULT(0)  |      |       |
# | created_at        | 作成日時          | datetime    | NOT NULL    |      |       |
# | updated_at        | 更新日時          | datetime    | NOT NULL    |      |       |
# |-------------------+-------------------+-------------+-------------+------+-------|

module Swars
  class User < ApplicationRecord
    has_many :memberships, dependent: :destroy # 対局時の情報(複数)
    has_many :battles, through: :memberships   # 対局(複数)
    belongs_to :grade                          # すべてのモードのなかで一番よい段級位
    has_many :search_logs, dependent: :destroy # 明示的に取り込んだ日時の記録

    before_validation do
      self.grade ||= Grade.last

      # Grade が下がらないようにする
      # 例えば10分メインの人が3分を1回やっただけで30級に戻らないようにする
      if changes[:grade_id]
        ov, nv = changes[:grade_id]
        if ov && nv
          if Grade.find(ov).priority < Grade.find(nv).priority
            self.grade_id = ov
          end
        end
      end
    end

    with_options presence: true do
      validates :user_key
    end

    with_options allow_blank: true do
      validates :user_key, uniqueness: true
    end

    def to_param
      user_key
    end

    concerning :StatMethods do
      def stat1
        stat = Hash.new(0)

        stat["集計した直近の対局数"] = memberships.count
        stat["勝ち"] = 0
        stat["負け"] = 0

        # lose_count = memberships.count { |e| membership.battle.win_user_id && membership.battle.win_user != self }

        memberships.each do |membership|
          battle = membership.battle
          key1 = "#{battle.final_info.name}で"

          if battle.win_user_id
            if battle.win_user == self
              win_or_lose = "勝ち"
            else
              win_or_lose = "負け"
            end
          else
            win_or_lose = "引き分け"
          end

          key = "#{key1}#{win_or_lose}"
          key = {
            "投了で勝ち" => "相手が投了した",
            "投了で負け" => "自分が投了した",
            "切断で勝ち" => "相手が切断した",
            "切断で負け" => "自分が切断した",
            "詰みで負け" => "詰まされて負けた",
            "詰みで勝ち" => "詰まして勝った",
          }.fetch(key, key)

          stat["#{win_or_lose}"] += 1
          stat["#{key}"] += 1

          #
          #   membership = ships[i]
          #   membership.defense_tag_list = player.skill_set.defense_infos.normalize.collect(&:key)
          #   membership.attack_tag_list  = player.skill_set.attack_infos.normalize.collect(&:key)
          # end

          # info = battle.parsed_info
          # defense_tag_list << info.mediator.players.flat_map { |e| e.skill_set.defense_infos.normalize.flat_map { |e| [e.name, *e.alias_names] } }
          # attack_tag_list  << info.mediator.players.flat_map { |e| e.skill_set.attack_infos.normalize.flat_map  { |e| [e.name, *e.alias_names] } }
        end

        stat["投了率"] = parcentage(stat["自分が投了した"], stat["負け"])
        stat["切断率"] = parcentage(stat["自分が切断した"], stat["負け"])

        stat
      end

      def stat2
        stat = Hash.new(0)
        memberships.each do |membership|
          membership.attack_tag_list.each { |e| stat[e] += 1 }
          membership.defense_tag_list.each { |e| stat[e] += 1 }
        end
        Hash[stat.sort_by { |k, v| -v }]
      end

      def parcentage(numerator, denominator)
        if denominator.zero?
          return ""
        end
        rate = (numerator * 100).fdiv(denominator).round(2)
        "#{rate} %"
      end
    end
  end
end
