# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 対局と対局者の対応 (swars_memberships as Swars::Membership)
#
# |----------------+----------------+-------------+-------------+-------------------+------------|
# | name           | desc           | type        | opts        | refs              | index      |
# |----------------+----------------+-------------+-------------+-------------------+------------|
# | id             | ID             | integer(8)  | NOT NULL PK |                   |            |
# | battle_id      | 対局共通情報   | integer(8)  | NOT NULL    |                   | A! B! C! D |
# | user_id        | ユーザー       | integer(8)  | NOT NULL    | => User#id        | B! E       |
# | op_user_id     | Op user        | integer(8)  |             | => Swars::User#id | C! F       |
# | grade_id       | 棋力           | integer(8)  | NOT NULL    |                   | G          |
# | judge_key      | 結果           | string(255) | NOT NULL    |                   | H          |
# | location_key   | 先手or後手     | string(255) | NOT NULL    |                   | A! I       |
# | position       | 順序           | integer(4)  |             |                   | J          |
# | grade_diff     | Grade diff     | integer(4)  | NOT NULL    |                   |            |
# | created_at     | 作成日時       | datetime    | NOT NULL    |                   |            |
# | updated_at     | 更新日時       | datetime    | NOT NULL    |                   |            |
# | think_all_avg  | Think all avg  | integer(4)  |             |                   |            |
# | think_end_avg  | Think end avg  | integer(4)  |             |                   |            |
# | two_serial_max | Two serial max | integer(4)  |             |                   |            |
# | think_last     | Think last     | integer(4)  |             |                   |            |
# | think_max      | Think max      | integer(4)  |             |                   |            |
# |----------------+----------------+-------------+-------------+-------------------+------------|
#
#- Remarks ----------------------------------------------------------------------
# Swars::User.has_many :op_memberships, foreign_key: :op_user_id
# User.has_one :profile
#--------------------------------------------------------------------------------

module Swars
  class Membership < ApplicationRecord
    include TagMethods
    include ::Swars::MembershipTimeChartMethods

    belongs_to :battle                      # 対局
    belongs_to :user, touch: true           # 対局者
    belongs_to :op_user, class_name: "Swars::User" # 相手
    belongs_to :opponent, class_name: "Membership", optional: true

    belongs_to :grade             # 対局したときの段位

    acts_as_list top_of_list: 0, scope: :battle

    before_validation do
      # テストを書きやすいようにする
      if Rails.env.development? || Rails.env.test?
        # self.user ||= User.create!

        m = (battle.memberships - [self]).first
        if m
          self.location_key ||= m.location&.flip&.key
          self.judge_key ||= m.judge_info&.flip&.key
        end

        if index = battle.memberships.find_index { |e| e == self }
          self.location_key ||= Bioshogi::Location[index].key
          self.judge_key ||= JudgeInfo[index].key
        end
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

      unless op_user_id
        if battle
          if m = (battle.memberships - [self]).first
            self.op_user_id = m.user_id
          end
        end
      end

      # 対戦相手との段級位の差を保持しておく
      unless grade_diff
        if m = (battle.memberships - [self]).first
          if grade && m.grade
            self.grade_diff = -(m.grade.priority - grade.priority)
          end
        end
      end

      # if think_max && think_last && think_all_avg && think_end_avg && two_serial_max
      # else
      #   # think_columns_update
      # end
    end

    with_options presence: true do
      validates :judge_key
      validates :user_id
      validates :op_user_id
      validates :location_key
    end

    with_options allow_blank: true do
      validates :judge_key, inclusion: JudgeInfo.keys.collect(&:to_s)
      validates :location_key, inclusion: Bioshogi::Location.keys.collect(&:to_s)

      if Rails.env.development? || Rails.env.test?
        with_options uniqueness: { scope: :battle_id, case_sensitive: true } do
          validates :user_id
          validates :op_user_id
          validates :location_key
        end
      end
    end

    def name_with_grade
      "#{user.key} #{grade.name}"
    end

    def location
      Bioshogi::Location[location_key]
    end

    def judge_info
      JudgeInfo[judge_key]
    end

    # 相手 FIXME: 消す
    def opponent
      @opponent ||= battle.memberships.where.not(position: position).take
    end

    def think_columns_update
      list = sec_list

      if Rails.env.development? || Rails.env.test?
        # パックマン戦法のKIFには時間が入ってなくて、その場合、時間が nil になるため。ただしそれは基本開発環境のみ
        list = list.compact
      end

      self.think_max  = list.max || 0
      self.think_last = list.last || 0

      d = list.size
      c = list.sum
      if d.positive?
        self.think_all_avg = c.div(d)
      end

      a = list.last(5)
      d = a.size
      c = a.sum
      if d.positive?
        self.think_end_avg = c.div(d)
      end

      a = list                                   # => [2, 3, 3, 2, 2, 2]
      x = a.chunk { |e| e == 2 }                 # => [[true, [2]], [false, [3, 3], [true, [2, 2, 2]]
      x = x.collect { |k, v| k ? v.size : nil }  # => [       1,            nil,           3        ]
      v = x.compact.max                          # => 3
      if v
        self.two_serial_max = v
      end
    end

    concerning :MedalMethods do
      def first_matched_medal
        MembershipMedalInfo.find { |e| e.if_cond.call(self) } or raise "must not happen"
      end

      def medal_params(params = {})
        info = first_matched_medal
        if v = (params[:debug] || ENV["MEDAL_DEBUG"])
          info = MembershipMedalInfo[(id + v.to_i).modulo(MembershipMedalInfo.count)]
        end
        info.medal_params_build(self)
      end

      def first_matched_medal_key_and_message
        [
          first_matched_medal.key,
          medal_params[:message],
        ]
      end

      def think_last_s
        seconds_to_human(think_last)
      end

      def think_max_s
        seconds_to_human(think_max)
      end

      private

      def seconds_to_human(seconds)
        seconds ||= 0
        if seconds.zero?
          "0秒"
        else
          m, s = seconds.divmod(60)
          a = []
          if m.positive?
            a << "#{m}分"
          end
          if s.positive?
            a << "#{s}秒"
          end
          a.join
        end
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
