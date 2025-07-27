# -*- coding: utf-8 -*-

# == Schema Information ==
#
# 対局と対局者の対応 (swars_memberships as Swars::Membership)
#
# |-----------------------+-----------------------+------------+-------------+-------------------------+------------|
# | name                  | desc                  | type       | opts        | refs                    | index      |
# |-----------------------+-----------------------+------------+-------------+-------------------------+------------|
# | id                    | ID                    | integer(8) | NOT NULL PK |                         |            |
# | battle_id             | 対局共通情報          | integer(8) | NOT NULL    |                         | A! B! C! E |
# | user_id               | ユーザー              | integer(8) | NOT NULL    | => User#id              | A! F       |
# | op_user_id            | Op user               | integer(8) |             | => Swars::User#id       | C! G       |
# | grade_id              | 棋力                  | integer(8) | NOT NULL    |                         | H          |
# | position              | 順序                  | integer(4) |             |                         | I          |
# | grade_diff            | Grade diff            | integer(4) | NOT NULL    |                         |            |
# | created_at            | 作成日時              | datetime   | NOT NULL    |                         |            |
# | updated_at            | 更新日時              | datetime   | NOT NULL    |                         |            |
# | think_all_avg         | Think all avg         | integer(4) |             |                         |            |
# | think_end_avg         | Think end avg         | integer(4) |             |                         |            |
# | think_last            | Think last            | integer(4) |             |                         |            |
# | think_max             | Think max             | integer(4) |             |                         |            |
# | ai_drop_total         | Ai drop total         | integer(4) |             |                         |            |
# | judge_id              | Judge                 | integer(8) | NOT NULL    | => Judge#id             | J          |
# | location_id           | Location              | integer(8) | NOT NULL    | => Location#id          | B! K       |
# | style_id              | Style                 | integer(8) |             |                         | L          |
# | ek_score_without_cond | Ek score without cond | integer(4) |             |                         |            |
# | ek_score_with_cond    | Ek score with cond    | integer(4) |             |                         |            |
# | ai_wave_count         | Ai wave count         | integer(4) |             |                         |            |
# | ai_two_freq           | Ai two freq           | float(24)  |             |                         |            |
# | ai_noizy_two_max      | Ai noizy two max      | integer(4) |             |                         |            |
# | ai_gear_freq          | Ai gear freq          | float(24)  |             |                         |            |
# | opponent_id           | Opponent              | integer(8) |             | => Swars::Membership#id | D!         |
# |-----------------------+-----------------------+------------+-------------+-------------------------+------------|
#
# - Remarks ----------------------------------------------------------------------
# Judge.has_many :swars_memberships
# Location.has_many :swars_memberships
# Swars::Membership.belongs_to :opponent
# Swars::User.has_many :op_memberships, foreign_key: :op_user_id
# User.has_one :profile
# --------------------------------------------------------------------------------

module Swars
  class Membership < ApplicationRecord
    include TagMethods
    include ::Swars::MembershipTimeChartMethods
    include FraudDetector::MembershipMethods
    include User::Stat::MembershipGlobalExtension

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

    belongs_to :user    # 対局者 (直近対局日時を更新する)
    belongs_to :op_user, class_name: "Swars::User" # 相手
    belongs_to :opponent, class_name: "Swars::Membership", optional: true

    acts_as_list top_of_list: 0, scope: :battle

    scope :rule_eq, -> v { joins(:battle).merge(Battle.rule_eq(v)) } # ルール "10分" や "ten_min" どちらでもOK

    scope :pro_only,   -> {     where(grade: Grade.fetch("十段")) }
    scope :pro_except, -> { where.not(grade: Grade.fetch("十段")) }

    scope :ban_only,   -> {     where(user: User.ban_only) }
    scope :ban_except, -> { where.not(user: User.ban_only) }

    scope :user_only,   -> user_keys {     where(user: User.user_only(user_keys)) }
    scope :user_except, -> user_keys { where.not(user: User.user_only(user_keys)) }

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

    if Rails.env.local?
      with_options allow_blank: true do
        with_options uniqueness: { scope: :battle_id, case_sensitive: true } do
          validates :user_id
          validates :op_user_id
        end
      end
    end

    after_create do
      if user.latest_battled_at < battle.battled_at
        user.update_columns(:latest_battled_at => battle.battled_at)
      end
    end

    # リレーションを使わない方法
    def opponent_slow
      @opponent_slow ||= (battle.memberships - [self]).first
    end

    def name_with_grade
      "#{user.key} #{grade.name}"
    end

    def name_with_grade_with_judge
      "#{user.key} #{grade.name} #{judge.name} (#{all_tag_names.join(" ")})"
    end

    # 先手 後手 下手 上手 を返す
    def location_human_name
      location.call_name(battle.handicap)
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

      # a = list                                   # => [2, 3, 3, 2, 2, 2]
      # x = a.chunk { |e| e == 2 }                 # => [[true, [2]], [false, [3, 3], [true, [2, 2, 2]]
      # x = x.collect { |k, v| k ? v.size : nil }  # => [       1,            nil,           3        ]
      # v = x.compact.max                          # => 3
      # if v
      #   self.two_serial_max = v
      # end

      ai_columns_set
    end

    def ai_columns_set
      list = sec_list

      # パックマン戦法のKIFには時間が入ってなくて、その場合、時間が nil になるため。ただしそれは基本開発環境のみ
      if Rails.env.local?
        list = list.compact
      end

      self.attributes = FraudDetector::Analyzer.analyze(list).db_attributes
    end

    def ai_columns_update!
      ai_columns_set
      save!
    end

    # for debug
    def info
      {
        "ID"         => id,
        "先後"       => location.name,
        "勝敗"       => judge_info.name,
        "棋力"       => grade_info.name,
        "力差"       => grade_diff,
        "スタイル"   => style_info&.name,
        "自分"       => name_with_grade,
        "相手"       => opponent.name_with_grade,
        "対"         => opponent.id,
        **tag_info,
      }
    end

    concerning :BadgeMethods do
      def badge_info
        MembershipBadgeInfo.find { |e| e.if_cond.call(self) } or raise "must not happen"
      end

      def badge_params(params = {})
        info = badge_info
        if v = params[:badge_debug]
          info = MembershipBadgeInfo[(id + v.to_i).modulo(MembershipBadgeInfo.count)]
        end
        info.badge_params_build(self)
      end

      def badge_key_with_messsage
        [
          badge_info.key,
          badge_params[:message],
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
        has_one :membership_extra, dependent: :destroy, autosave: true
      end
    end

    concerning :StyleMethos do
      def style_update(player)
        if main_style_info = player.tag_bundle.main_style_info
          self.style = Style.fetch(main_style_info.key)
        else
          self.style = nil
        end
      end
    end
  end
end
