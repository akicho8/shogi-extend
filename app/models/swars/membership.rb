# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 対局と対局者の対応 (swars_memberships as Swars::Membership)
#
# |-----------------------+-----------------------+------------+-------------+-------------------+------------|
# | name                  | desc                  | type       | opts        | refs              | index      |
# |-----------------------+-----------------------+------------+-------------+-------------------+------------|
# | id                    | ID                    | integer(8) | NOT NULL PK |                   |            |
# | battle_id             | 対局共通情報          | integer(8) | NOT NULL    |                   | A! B! C! D |
# | user_id               | ユーザー              | integer(8) | NOT NULL    | => User#id        | A! E       |
# | op_user_id            | Op user               | integer(8) |             | => Swars::User#id | C! F       |
# | grade_id              | 棋力                  | integer(8) | NOT NULL    |                   | G          |
# | position              | 順序                  | integer(4) |             |                   | H          |
# | grade_diff            | Grade diff            | integer(4) | NOT NULL    |                   |            |
# | created_at            | 作成日時              | datetime   | NOT NULL    |                   |            |
# | updated_at            | 更新日時              | datetime   | NOT NULL    |                   |            |
# | think_all_avg         | Think all avg         | integer(4) |             |                   |            |
# | think_end_avg         | Think end avg         | integer(4) |             |                   |            |
# | two_serial_max        | Two serial max        | integer(4) |             |                   |            |
# | think_last            | Think last            | integer(4) |             |                   |            |
# | think_max             | Think max             | integer(4) |             |                   |            |
# | obt_think_avg         | Obt think avg         | integer(4) |             |                   |            |
# | obt_auto_max          | Obt auto max          | integer(4) |             |                   |            |
# | judge_id              | Judge                 | integer(8) | NOT NULL    | => Judge#id       | I          |
# | location_id           | Location              | integer(8) | NOT NULL    | => Location#id    | B! J       |
# | style_id              | Style                 | integer(8) |             |                   | K          |
# | ek_score_without_cond | Ek score without cond | integer(4) |             |                   |            |
# | ek_score_with_cond    | Ek score with cond    | integer(4) |             |                   |            |
# |-----------------------+-----------------------+------------+-------------+-------------------+------------|
#
#- Remarks ----------------------------------------------------------------------
# Judge.has_many :swars_memberships
# Location.has_many :swars_memberships
# Swars::User.has_many :op_memberships, foreign_key: :op_user_id
# User.has_one :profile
#--------------------------------------------------------------------------------

module Swars
  class Membership < ApplicationRecord
    include TagMethods
    include ::Swars::MembershipTimeChartMethods

    custom_belongs_to :location, ar_model: Location, st_model: LocationInfo, default: nil

    if Rails.env.local?
      with_options allow_blank: true do
        validates :location_id, uniqueness: { scope: :battle_id, case_sensitive: true }
      end
    end

    custom_belongs_to :judge, ar_model: Judge, st_model: JudgeInfo, default: nil
    custom_belongs_to :grade, ar_model: Grade, st_model: GradeInfo, default: nil
    custom_belongs_to :style, ar_model: Style, st_model: StyleInfo, default: nil, optional: true

    belongs_to :battle                      # 対局

    # 投了・時間切れ・詰み のみに絞る
    #
    #  SELECT m.* FROM m
    #  INNER JOIN b ON b.id = m.b_id
    #  INNER JOIN f ON f.id = b.f_id WHERE (f.key = 'TORYO' OR f.key = 'TIMEOUT' OR f.key = 'CHECKMATE')
    #
    scope :toryo_timeout_checkmate_only, -> { joins(:battle).merge(Battle.toryo_timeout_checkmate_only) }

    belongs_to :user, touch: true           # 対局者
    belongs_to :op_user, class_name: "Swars::User" # 相手
    belongs_to :opponent, class_name: "Membership", optional: true

    acts_as_list top_of_list: 0, scope: :battle

    scope :rule_eq, -> v { joins(:battle).merge(Battle.rule_eq(v)) } # ルール "10分" や "ten_min" どちらでもOK

    before_validation do

      # テストを書きやすいようにする
      if Rails.env.local?

        # self.user ||= User.create!

        m = (battle.memberships - [self]).first
        if m
          self.location_key ||= m.location_info&.flip&.key
          self.judge_key ||= m.judge_info&.flip&.key
        end

        if index = battle.memberships.find_index { |e| e == self }
          self.location_key ||= LocationInfo[index].key
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

      if Rails.env.local?
        self.grade ||= Grade.first
      end

      if !op_user_id
        if battle
          if m = (battle.memberships - [self]).first
            self.op_user_id = m.user_id
          end
        end
      end

      # 対戦相手との段級位の差を保持しておく
      if !grade_diff
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
      validates :user_id
      validates :op_user_id
    end

    with_options allow_blank: true do
      if Rails.env.local?
        with_options uniqueness: { scope: :battle_id, case_sensitive: true } do
          validates :user_id
          validates :op_user_id
        end
      end
    end

    def name_with_grade
      "#{user.key} #{grade.name}"
    end

    # 相手 FIXME: 消す
    def opponent
      @opponent ||= battle.memberships.where.not(position: position).take
    end

    def think_columns_update
      list = sec_list

      if Rails.env.local?
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

      think_columns_update2
    end

    # t.integer :obt_think_avg,   null: true, comment: "開戦後の指し手の平均秒数"
    # t.integer :obt_auto_max,  null: true, comment: "開戦後の2秒の指し手が連続した回数"
    # t.integer :think_max2,       null: true, comment: "開戦後の最大考慮秒数"
    def think_columns_update2
      list = sec_list

      if Rails.env.local?
        # パックマン戦法のKIFには時間が入ってなくて、その場合、時間が nil になるため。ただしそれは基本開発環境のみ
        list = list.compact
      end

      if battle.outbreak_turn
        # 全体が [a i b j c k d l]
        # 自分側の list が [a b c d e]
        # outbreak_turn が c の部分の 5 とすると
        # 5 / 2 で 2 なので [a b c d e].drop(2) で [c d e] が list に残る
        # これが開戦後の指し手
        from = battle.outbreak_turn / 2
        list = list.drop(from)

        # self.think_max2  = list.max || 0

        d = list.size
        c = list.sum
        if d.positive?
          self.obt_think_avg = c.div(d) # 中盤以降の指し手の平均
        end

        a = list                                   # => [2, 3, 3, 2, 1, 2]
        x = a.chunk { |e| e == 1 || e == 2 }       # => [[true, [2]], [false, [3, 3], [true, [2, 1, 2]]
        x = x.collect { |k, v| k ? v.size : nil }  # => [       1,            nil,           3        ]
        v = x.compact.max                          # => 3
        if v
          self.obt_auto_max = v # 中盤以降で 1 or 2 秒が続く回数の最大
        end

        # if Rails.env.development?
        #   p [obt_think_avg, obt_auto_max]
        # end
      end
    end

    concerning :MedalMethods do
      def first_matched_medal
        MembershipMedalInfo.find { |e| e.if_cond.call(self) } or raise "must not happen"
      end

      def medal_params(params = {})
        info = first_matched_medal
        if v = (params[:medal_debug] || ENV["MEDAL_DEBUG"])
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
      # 使用時間
      def total_seconds
        @total_seconds ||= sec_list.sum
      end

      # 残した秒数
      def rest_sec
        @rest_sec ||= battle.rule_info.life_time - total_seconds
      end
    end

    concerning :MembershipExtraMethods do
      included do
        # has_many :swars_battles, through: :swars_memberships, :source => <name>
        has_one :membership_extra, dependent: :destroy, autosave: true
        # scope :membership_extra_missing, -> { left_joins(:membership_extra).where(membership_extra: {id: nil}) }
      end
    end

    concerning :StyleMethos do
      def style_update(player)
        infos = []
        infos += player.skill_set.attack_infos
        infos += player.skill_set.defense_infos
        rarity_infos = infos.collect { |e|
          if e = Bioshogi::Explain::DistributionRatio[e.key]
            RarityInfo.fetch(e[:rarity_key])
          end
        }.compact
        if rarity_info = rarity_infos.compact.min_by(&:code)
          self.style = rarity_info.style_info.db_record!
        else
          self.style = nil
        end
      end
    end
  end
end
