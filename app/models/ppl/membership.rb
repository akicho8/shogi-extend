# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Membership (ppl_memberships as Ppl::Membership)
#
# |------------------+---------------+-------------+-------------+------------+-------|
# | name             | desc          | type        | opts        | refs       | index |
# |------------------+---------------+-------------+-------------+------------+-------|
# | id               | ID            | integer(8)  | NOT NULL PK |            |       |
# | season_id | League season | integer(8)  | NOT NULL    |            | A! B  |
# | user_id          | User          | integer(8)  | NOT NULL    | => User#id | A! C  |
# | result_id        | Result        | integer(8)  | NOT NULL    |            | D     |
# | age              | Age           | integer(4)  |             |            |       |
# | win              | Win           | integer(4)  | NOT NULL    |            | E     |
# | lose             | Lose          | integer(4)  | NOT NULL    |            |       |
# | ox               | Ox            | string(255) | NOT NULL    |            |       |
# | created_at       | 作成日時      | datetime    | NOT NULL    |            |       |
# | updated_at       | 更新日時      | datetime    | NOT NULL    |            |       |
# |------------------+---------------+-------------+-------------+------------+-------|
#
# - Remarks ----------------------------------------------------------------------
# User.has_one :profile
# --------------------------------------------------------------------------------

module Ppl
  class Membership < ApplicationRecord
    belongs_to :season                                                           # 対局
    belongs_to :user, counter_cache: true                                               # 参加者
    custom_belongs_to :result, ar_model: Result, st_model: ResultInfo, default: :retain # 結果

    before_validation do
      self.age ||= 0
      self.ox ||= ""
    end

    with_options allow_blank: true do
      validates :ranking_pos, numericality: { greater_than_or_equal_to: 1 }

      if false
        # 順位は重複するためユニーク制限してはいけない
        # https://www.ne.jp/asahi/yaston/shogi/syoreikai/3dan/league/3dan_league02.htm
        validates :ranking_pos, uniqueness: { scope: :season_id }
      end
    end

    after_save :user_record_update

    ################################################################################

    def user_record_update
      user_age_set
      user_result_set
      user_term_set
      user_win_lose_set
      user.save!
    end

    def user_age_set
      user.age_min = user.memberships.minimum(:age)
      user.age_max = user.memberships.maximum(:age)
    end

    def user_result_set
      if saved_change_to_attribute?(:result_id)
        if result.key == "runner_up"
          user.runner_up_count ||= 0
          user.runner_up_count += 1
        end
        if result.key == "promotion" || (user.runner_up_count || 0) >= User::PROMOTABLE_RUNNER_UP_COUNT
          user.promotion_membership = self
          user.promotion_season_position = season.position
          user.promotion_win = win
        end
      end
    end

    # 在籍の開始と終了のレコードを一発で引けるようにしておく
    def user_term_set
      user.memberships_first, user.memberships_last = user.memberships.minmax_by { |e| e.season.position }
    end

    # 勝ち負けに関する情報を反映する
    def user_win_lose_set
      user.win_max = user.memberships.collect(&:win).compact.max

      if true
        # 通常の三段リーグではこちらでよいのだが、
        # user.total_win  = user.memberships.sum(:win)
        # user.total_lose = user.memberships.sum(:lose)

        # なければ memberships に勝ち負けがなければ nil を設定するため DB の sum は使うな
        # user.total_win  = user.memberships.collect(&:win).compact.reduce(:+)
        # user.total_lose = user.memberships.collect(&:lose).compact.reduce(:+)

        # S49 頃の三段リーグは win, lose を昇段時のみに利用しているので勝率を出すにはこちらでないとだめ
        total_win  = user.memberships.sum(&:o_count_of_ox)
        total_lose = user.memberships.sum(&:x_count_of_ox)

        # win_ratio 更新
        if total_win && total_lose
          denominator = total_win + total_lose
          if denominator.nonzero?
            user.win_ratio = total_win.fdiv(denominator)
          end
        end
      end
    end

    ################################################################################

    def o_count_of_ox
      @o_count_of_ox ||= ox.count("o")
    end

    def x_count_of_ox
      @x_count_of_ox ||= ox.count("x")
    end

    def ox_win_ratio
      @ox_win_ratio ||= yield_self do
        denominator = o_count_of_ox + x_count_of_ox
        if denominator.nonzero?
          o_count_of_ox.fdiv(denominator)
        end
      end
    end

    def ox_win_ratio_to_s
      if ox_win_ratio
        "%.3f" % ox_win_ratio
      end
    end

    ################################################################################
  end
end
