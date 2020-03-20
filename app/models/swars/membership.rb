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
# | grade_diff   | Grade diff   | integer(4)  | NOT NULL    |      | I       |
# | think_max    | Think max    | integer(4)  |             |      |         |
# |--------------+--------------+-------------+-------------+------+---------|

module Swars
  class Membership < ApplicationRecord
    include TagMod
    include ::Swars::MembershipTimeChartMod

    belongs_to :battle            # 対局
    belongs_to :user, touch: true # 対局者
    belongs_to :grade             # 対局したときの段位

    acts_as_list top_of_list: 0, scope: :battle

    # default_scope { order(:position) }

    scope :judge_key_eq, -> v { where(judge_key: v).take }

    before_validation do
      # テストを書きやすいようにする
      if Rails.env.development? || Rails.env.test?
        if index = battle.memberships.find_index { |e| e == self }
          self.location_key ||= Bioshogi::Location[index].key
          self.judge_key ||= JudgeInfo[index].key
        end
      end

      if Rails.env.development? || Rails.env.test?
        self.user ||= User.create!
      end

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

      if Rails.env.development? || Rails.env.test?
        self.grade ||= Grade.first
      end

      # 対戦相手との段級位の差を保持しておく
      if battle
        rival = (battle.memberships - [self]).first
        if grade && rival.grade
          self.grade_diff = -(rival.grade.priority - grade.priority)
        end
      end
    end

    with_options presence: true do
      validates :judge_key
      validates :location_key
    end

    with_options allow_blank: true do
      validates :judge_key, inclusion: JudgeInfo.keys.collect(&:to_s)
      validates :user_id, uniqueness: { scope: :battle_id, case_sensitive: true }
      validates :location_key, uniqueness: { scope: :battle_id, case_sensitive: true }
      validates :location_key, inclusion: Bioshogi::Location.keys.collect(&:to_s)
    end

    def name_with_grade
      "#{user.user_key} #{grade.name}"
    end

    def location
      Bioshogi::Location.fetch(location_key)
    end

    def judge_info
      JudgeInfo.fetch(judge_key)
    end

    # 相手
    def opponent
      @opponent ||= battle.memberships.where.not(position: position).take
    end

    concerning :HelperMethods do
      def icon_html
        # judge_info = JudgeInfo.to_a.sample
        # final_info = FinalInfo.to_a.sample
        # grade_diff = rand(-1..1)

        if icon = judge_info.icon_params(self) || battle.final_info.icon_params(self)
          if icon.kind_of?(String)
            icon
          else
            Icon.icon_tag(*icon[:key], :class => icon[:class])
          end
        end
      end

      def winner_only_icon_html
        if judge_info.key == :win
          icon_html
        end
      end

      def card_emoji
        judge_info.card_emoji(self) || battle.final_info.card_emoji(self)
      end
    end

    concerning :SummaryMethods do
      def raw_summary_key
        @raw_summary_key ||= "#{battle.final_info.name}で#{judge_info.name}"
      end

      def summary_key
        @summary_key ||= summary_key_translate_hash.fetch(raw_summary_key, raw_summary_key)
      end

      # def summary_store_to(stat)
      #   stat[summary_key] ||= []
      #   stat[summary_key] << self
      #   stat
      # end

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

      def swgod_level1_used?
        @swgod_level1_used ||= -> {
          if battle.fast_parsed_info.move_infos.size >= swgod_move_getq
            list = sec_list.last(swgod_last_n)
            if list.size >= swgod_hand_times
              list.each_cons(swgod_hand_times).any? { |list| list.sum <= swgod_time_limit }
            end
          end
        }.call
      end

      def swgod_10min_winner_used?
        if battle.rule_info.key == :ten_min || battle.rule_info.key == :ten_sec
          if judge_info.key == :win
            swgod_level1_used?
          end
        end
      end

      def winner?
        # battle.win_user == user
        judge_info.key == :win
      end
    end
  end
end
