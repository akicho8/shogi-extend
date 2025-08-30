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

module Swars
  class User < ApplicationRecord
    include GradeMethods
    include GeneralScopeMethods
    include SearchMethods
    include BanMethods

    class << self
      def [](key)
        find_by(key: key)
      end

      def fetch(key)
        find_by!(key: key)
      end
    end

    alias_attribute :key, :user_key

    has_one :profile, dependent: :destroy, autosave: true # プロフィール

    has_many :memberships, dependent: :destroy # 対局時の情報(複数)
    has_many :battles, through: :memberships   # 対局(複数)

    has_many :op_memberships, class_name: "Membership", foreign_key: "op_user_id", dependent: :destroy # (対戦相手の)対局時の情報(複数)
    has_many :op_users, through: :op_memberships, source: :user, class_name: "Swars::User" # Rails 8 以上では class_name 必須

    has_many :search_logs, dependent: :destroy # 明示的に取り込んだ日時の記録

    normalizes :user_key, with: -> e { e.to_s } # UserKey 型で来る場合もあるため

    before_validation on: :create do
      if Rails.env.local?
        self.key ||= "#{self.class.name.demodulize.underscore}#{self.class.count.next}"
      end
      self.key ||= SecureRandom.hex
      self.latest_battled_at ||= Time.current

      if Rails.env.local?
        self.soft_crawled_at ||= latest_battled_at
        self.hard_crawled_at ||= latest_battled_at
      end

      profile || build_profile
    end

    with_options presence: true do
      validates :key
      validates :latest_battled_at
    end

    def to_param
      key
    end

    def key_info
      @key_info ||= UserKey[key]
    end
    delegate *UserKey::DELEGATE_METHODS, to: :key_info

    # 引数があるけどキャッシュするので注意
    def cached_stat(...)
      @cached_stat ||= stat(...)
    end

    def stat(...)
      Stat::Main.new(self, ...)
    end

    def to_h
      {
        "ID"           => id,
        "ウォーズID"   => key,
        "段級"         => grade.name,
        "最終対局日時" => latest_battled_at&.to_fs(:ymdhms),
        "対局数"       => memberships.size,
        "BAN日時"      => ban_at&.to_fs(:ymdhms),
        "BAN確認数"    => profile.ban_crawled_count,
        "BAN確認日時"  => profile.ban_crawled_at&.to_fs(:ymdhms),
        "検索数"       => search_logs.count,
        "直近検索"     => last_reception_at&.to_fs(:ymdhms),
        "登録日時"     => created_at.to_fs(:ymdhms),
        "現在日時"     => Time.current.to_fs(:ymdhms),
      }
    end
  end
end
