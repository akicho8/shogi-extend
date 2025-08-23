# -*- coding: utf-8 -*-

# == Schema Information ==
#
# ユーザー (users as User)
#
# |------------------------+----------------------------+-------------+---------------------+------+-------|
# | name                   | desc                       | type        | opts                | refs | index |
# |------------------------+----------------------------+-------------+---------------------+------+-------|
# | id                     | ID                         | integer(8)  | NOT NULL PK         |      |       |
# | key                    | キー                       | string(255) | NOT NULL            |      | A!    |
# | name                   | 名前                       | string(255) | NOT NULL            |      |       |
# | race_key               | 種族                       | string(255) | NOT NULL            |      | F     |
# | name_input_at          | Name input at              | datetime    |                     |      |       |
# | created_at             | 作成日                     | datetime    | NOT NULL            |      |       |
# | updated_at             | 更新日                     | datetime    | NOT NULL            |      |       |
# | email                  | メールアドレス             | string(255) | NOT NULL            |      | B!    |
# | encrypted_password     | 暗号化パスワード           | string(255) | NOT NULL            |      |       |
# | reset_password_token   | Reset password token       | string(255) |                     |      | C!    |
# | reset_password_sent_at | パスワードリセット送信時刻 | datetime    |                     |      |       |
# | remember_created_at    | ログイン記憶時刻           | datetime    |                     |      |       |
# | sign_in_count          | ログイン回数               | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | current_sign_in_at     | 現在のログイン時刻         | datetime    |                     |      |       |
# | last_sign_in_at        | 最終ログイン時刻           | datetime    |                     |      |       |
# | current_sign_in_ip     | 現在のログインIPアドレス   | string(255) |                     |      |       |
# | last_sign_in_ip        | 最終ログインIPアドレス     | string(255) |                     |      |       |
# | confirmation_token     | パスワード確認用トークン   | string(255) |                     |      | D!    |
# | confirmed_at           | パスワード確認時刻         | datetime    |                     |      |       |
# | confirmation_sent_at   | パスワード確認送信時刻     | datetime    |                     |      |       |
# | unconfirmed_email      | 未確認Eメール              | string(255) |                     |      |       |
# | failed_attempts        | 失敗したログイン試行回数   | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | unlock_token           | Unlock token               | string(255) |                     |      | E!    |
# | locked_at              | ロック時刻                 | datetime    |                     |      |       |
# |------------------------+----------------------------+-------------+---------------------+------+-------|

# frozen-string-literal: true

module Ppl
  class User < ApplicationRecord
    PROMOTABLE_RUNNER_UP_COUNT = 2 # 昇段の権利を取得できる次点の数

    class << self
      def [](name)
        find_by(name: name)
      end

      def fetch(name)
        find_by!(name: name)
      end
    end

    has_many :memberships, dependent: :destroy      # 対局時の情報(複数)
    has_many :seasons, through: :memberships # 対局(複数)

    belongs_to :mentor, counter_cache: true, optional: true # 師匠 (いない人もいる)

    custom_belongs_to :rank, ar_model: Rank, st_model: RankInfo, default: :active_member # 昇段→フリ→現役→退会

    with_options class_name: "Ppl::Membership", optional: true do
      belongs_to :memberships_first      # 所属開始したときの時期
      belongs_to :memberships_last       # 所属終了したときの時期 (まだ現役かもしれない)
      belongs_to :deactivated_membership # 所属終了したときの時期 (この期を最後に退会した)
      belongs_to :promotion_membership   # 昇段したときの時期
    end

    # 最優先で「昇段している人」「昇段していない人」の順にする
    # 非常にわかりにくいが promotion_season_number IS NULL で値があれば false つまり 0 になるため上にくる
    # そのあとで promotion_season_number: asc なので昇段している中ではなるべく先輩から表示する
    # このようにすることで、期を絞ったときその期で昇段した人が上にくるのでわかりやすい
    scope :table_order,  -> {
      order([
          Rank.arel_table[:position].asc,
          { promotion_season_position: :asc },
          { promotion_win: :desc },
          { runner_up_count: :desc },
          { age_min: :asc },
          { memberships_count: :asc },
        ])
      }

    # 最近昇段した人ほど手前にくる
    scope :link_order,  -> {
      order([
          Rank.arel_table[:position].asc,
          { promotion_season_position: :desc },
          { promotion_win: :desc },
          { runner_up_count: :desc },
          { age_min: :asc },
          { memberships_count: :asc },
        ])
      }

    scope :json_order, -> { link_order }

    scope :plus_minus_search, -> query do
      scope = all
      SimpleQueryParser.parse(query.to_s).each do |plus, queries|
        queries.each do |query|
          sanitized = ActiveRecord::Base.sanitize_sql_like(query.downcase)
          scope = scope.where("#{plus ? '' : 'NOT'} (LOWER(#{table_name}.name) LIKE ?)", "%#{sanitized}%")
        end
      end
      scope
    end

    scope :search, -> (params = {}) { UserSearch.call(all, params) }

    normalizes :name, with: -> e { NameNormalizer.normalize(e) }

    before_validation do
      self.age_min ||= 0
      self.age_max ||= 0
    end

    with_options presence: true do
      validates :name
    end

    with_options allow_blank: true do
      validates :name, uniqueness: true
    end

    # 「昇段」or「次点2つ」か？
    def promoted_or_rights
      promotion_membership_id || promotion_by_runner_up_count?
    end

    # 「次点2つ」によって昇段の権利を得たか？
    def promotion_by_runner_up_count?
      (runner_up_count || 0) >= PROMOTABLE_RUNNER_UP_COUNT
    end

    # 昇段した年齢
    def promotion_age
      promotion_membership&.age
    end

    # 退会した？ (連盟が「降」を書かないため退会したのか降段なのかわからない)
    def deactivated?
      deactivated_membership
    end

    # 現役会員と思われる？
    def active?
      !deactivated_membership
    end

    # 状態
    def rank_key_without_rank
      if promotion_membership
        if promotion_membership.result_key == "promotion"
          :true_professional
        else
          :substitute_professional
        end
      elsif deactivated_membership
        :resigned
      else
        :active_member
      end
    end

    # 退会することにしたシーズンを得る
    # 自分が参加した最後のシーズンよりあとに知らないシーズンがあるということは自分は退会している
    def update_deactivated_season
      scope = Season.where(Season.arel_table[:position].gt(memberships_last.season.position)).oldest_order
      scope = scope.includes(:users)
      season = scope.first

      if season
        # 未来に自分が参加していないシーズンがあるといと memberships_last を最後に退会した
        self.deactivated_membership = memberships_last
      else
        # 次のシーズンがないということは最新のシーズン所属している
        self.deactivated_membership = nil
      end

      self.rank_key = rank_key_without_rank

      save!
    end
  end
end
