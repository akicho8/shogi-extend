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
# | user_agent             | User agent                 | string(255) | NOT NULL            |      |       |
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

module Swars
  class User < ApplicationRecord
    alias_attribute :key, :user_key

    has_one :profile, dependent: :destroy, autosave: true # プロフィール
    has_many :ban_crawl_requests, dependent: :destroy     # 垢BAN確認リクエストたち

    has_many :memberships, dependent: :destroy # 対局時の情報(複数)
    has_many :battles, through: :memberships   # 対局(複数)

    has_many :op_memberships, class_name: "Membership", foreign_key: "op_user_id", dependent: :destroy # (対戦相手の)対局時の情報(複数)
    has_many :op_users, through: :op_memberships, source: :user

    has_many :search_logs, dependent: :destroy # 明示的に取り込んだ日時の記録

    scope :recently_only, -> { where.not(last_reception_at: nil).order(last_reception_at: :desc)              } # 最近使ってくれた人たち順
    scope :regular_only,  -> { order(search_logs_count: :desc)                                                } # 検索回数が多い人たち順
    scope :great_only,    -> { joins(:grade).order(Grade.arel_table[:priority].desc).order(updated_at: :desc) } # 段級位が高い人たち順

    before_validation do
      if Rails.env.local?
        self.user_key ||= "#{self.class.name.demodulize.underscore}#{self.class.count.next}"
      end
      self.user_key ||= SecureRandom.hex

      profile || build_profile
    end

    with_options presence: true do
      validates :user_key
    end

    with_options allow_blank: true do
      validates :user_key, uniqueness: { case_sensitive: true } # FIXME: これ取る
    end

    def to_param
      user_key
    end

    def user_info(params = {})
      UserInfo::Main.new(self, params)
    end

    concerning :GradeMethods do
      included do
        custom_belongs_to :grade, ar_model: Grade, st_model: GradeInfo, default: "30級" # すべてのモードのなかで一番よい段級位

        if Rails.env.local?
          before_validation do
            if Grade.count.zero?
              Swars.setup
            end
          end
        end
      end

      # 指定の grade の方が段位が上であれば設定する
      def grade_update_if_new(new_grade)
        if grade
          if new_grade.priority < grade.priority
            self.grade = new_grade
          end
        else
          self.grade = grade
        end
        save!
      end

      def name_with_grade
        "#{user_key} #{grade.name}"
      end
    end

    concerning :ProfileBanMethods do
      included do

        before_save do
          if changes_to_save[:ban_at]
            profile.ban_at = ban_at
          end
        end

        scope :ban_only,   -> { where.not(ban_at: nil) }                # BANされた人たち
        scope :ban_except, -> { where(ban_at: nil)     }                # BANされた人たちを除く
        scope :pro_except, -> { where.not(grade: Grade.fetch("十段")) } # プロを除く

        # BAN確認対象者
        scope :ban_crawl_scope, -> (options = {}) {
          s = all                                         # 全員
          s = s.ban_except                                # BANされた人たちを除く
          s = s.pro_except                                # プロを除く
          if v = options[:grade]
            s = s.where(grade: Grade.fetch(v))
          end
          if v = options[:limit]
            s = s.limit(v)
          end
          s
        }
      end

      class_methods do
        # rails r 'Swars::User.ban_crawler'
        def ban_crawler(...)
          BanCrawler.new(...).call
        end
      end

      def ban_clear
        self.ban_at = nil
        save!
      end

      def ban_set(state = true)
        time = Time.current
        value = nil
        if state
          value = time
        end
        self.ban_at = value
        profile.ban_crowled_at = time
      end

      def ban!
        ban_set(true)
        save!
      end
    end
  end
end
