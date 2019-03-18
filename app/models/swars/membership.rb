# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 対局と対局者の対応 (swars_memberships as Swars::Membership)
#
# |--------------+--------------+-------------+-------------+------+---------|
# | name         | desc         | type        | opts        | refs | index   |
# |--------------+--------------+-------------+-------------+------+---------|
# | id           | ID           | integer(8)  | NOT NULL PK |      |         |
# | battle_id    | 対局共通情報 | integer(8)  | NOT NULL    |      | A! B! C |
# | user_id      | ユーザー     | integer(8)  | NOT NULL    |      | B! D    |
# | grade_id     | 棋力         | integer(8)  | NOT NULL    |      | E       |
# | judge_key    | 結果         | string(255) | NOT NULL    |      | F       |
# | location_key | 先手or後手   | string(255) | NOT NULL    |      | A! G    |
# | position     | 順序         | integer(4)  |             |      | H       |
# | created_at   | 作成日時     | datetime    | NOT NULL    |      |         |
# | updated_at   | 更新日時     | datetime    | NOT NULL    |      |         |
# |--------------+--------------+-------------+-------------+------+---------|

module Swars
  class Membership < ApplicationRecord
    belongs_to :battle            # 対局
    belongs_to :user, touch: true # 対局者
    belongs_to :grade             # 対局したときの段位

    acts_as_list top_of_list: 0, scope: :battle

    default_scope { order(:position) }

    scope :judge_key_eq, -> v { where(judge_key: v).take }

    # 先手/後手側の対局時の情報
    scope :black, -> { where(location_key: "black").take! }
    scope :white, -> { where(location_key: "white").take! }

    # # 勝者/敗者側の対局時の情報(引き分けの場合ない)
    # scope :win,  -> { judge_key_eq(:win)  }
    # scope :lose, -> { judge_key_eq(:lose) }

    # user に対する自分/相手
    scope :myself, -> user { where(user_id: user.id).take!     }
    scope :rival,  -> user { where.not(user_id: user.id).take! }

    acts_as_ordered_taggable_on :defense_tags
    acts_as_ordered_taggable_on :attack_tags
    acts_as_ordered_taggable_on :technique_tags

    before_validation do
      if user
        # 無かったときだけ入れる(絶対あるんだけど)
        self.grade ||= user.grade

        # 簡単にするため battle の方に勝者を入れておく
        if judge_key
          if judge_info.key == :win
            battle.win_user ||= user
          end
        end
      end
    end

    with_options presence: true do
      validates :judge_key
      validates :location_key
    end

    with_options allow_blank: true do
      validates :judge_key, inclusion: JudgeInfo.keys.collect(&:to_s)
      validates :user_id, uniqueness: {scope: :battle_id}
      validates :location_key, uniqueness: {scope: :battle_id}
      validates :location_key, inclusion: Warabi::Location.keys.collect(&:to_s)
    end

    def name_with_grade
      "#{user.user_key} #{grade.name}"
    end

    def location
      Warabi::Location.fetch(location_key)
    end

    def judge_info
      JudgeInfo.fetch(judge_key)
    end

    concerning :SummaryMethods do
      def summary_key
        key = "#{battle.final_info.name}で#{judge_info.name}"
        summary_key_translate_hash.fetch(key, key)
      end

      def summary_store_to(stat)
        stat[summary_key] += 1
        stat
      end

      # 使用時間
      def total_seconds
        @total_seconds ||= sec_list.sum
      end

      # 残した秒数
      def rest_sec
        @rest_sec ||= battle.rule_info.life_time - total_seconds
      end

      private

      def summary_key_translate_hash
        @summary_key_translate_hash ||= {
          "投了で勝ち"     => "投了された",
          "投了で負け"     => "投了した",
          "切断で勝ち"     => "切断された",
          "切断で負け"     => "切断した",
          "詰みで負け"     => "詰まされた",
          "詰みで勝ち"     => "詰ました",
          "時間切れで負け" => "切れ負け",
          "時間切れで勝ち" => "切れ勝ち",
        }
      end
    end

    concerning :KishinInfoMethods do
      included do
        cattr_accessor(:swgod_move_getq)  { 60 } # お互い合わせて何手以上で
        cattr_accessor(:swgod_last_n)     { 10 } # 最後の片方の手の N 手内に
        cattr_accessor(:swgod_hand_times) { 5  } # 棋神は1回でN手指される
        cattr_accessor(:swgod_time_limit) { 9  } # 5手がN秒以内なら
      end

      def sec_list
        @sec_list ||= -> {
          base = battle.preset_info.to_turn_info.base_location.code
          battle.parsed_info.move_infos.find_all.with_index(base) { |e, i| i.modulo(Warabi::Location.count) == position }.collect { |e| e[:used_seconds] }
        }.call
      end

      def swgod_level1_used?
        if battle.parsed_info.move_infos.size >= swgod_move_getq
          list = sec_list.last(swgod_last_n)
          if list.size >= swgod_hand_times
            list.each_cons(swgod_hand_times).any? { |list| list.sum <= swgod_time_limit }
          end
        end
      end

      def swgod_10min_winner_used?
        if battle.rule_info.key == :ten_min
          if swgod_level1_used?
            if judge_info.key == :win
              if swgod_level1_used?
                true
              end
            end
          end
        end
      end

      def winner?
        # battle.win_user == user
        judge_info.key == :win
      end

      def swgod_info
        {
          "判定"         => swgod_10min_winner_used? ? "80 %" : "0 %",
          "指し手の秒数" => sec_list,
          "結果"         => winner? ? "勝ち" : "",
        }
      end
    end
  end
end
