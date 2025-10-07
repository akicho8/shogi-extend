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

module ShareBoard
  class User < ApplicationRecord
    class << self
      def [](...)
        lookup(...)
      end

      def lookup(name)
        find_by(name: name)
      end

      def fetch(name)
        find_by!(name: name)
      end
    end

    has_many :memberships, dependent: :destroy                   # 対局時の情報(複数)
    has_many :battles, through: :memberships                     # 対局(複数)
    has_many :rooms, through: :memberships                       # 対局部屋(複数)

    has_many :chat_messages, dependent: :destroy                 # このユーザーの発言たち (すべての部屋での発言)
    has_many :chat_rooms, through: :chat_messages, source: :room # このユーザーが発言した部屋たち

    before_validation do
      self.name ||= "(name#{self.class.count.next})"
      self.name = StringSupport.user_message_normalize(name)
    end

    with_options presence: true do
      validates :name
    end

    with_options allow_blank: true do
      validates :name, uniqueness: { case_sensitive: true }
    end

    def score_by_room(room)
      room.score_by_user(self)
      # room.memberships.where(user: self, judge: Judge.fetch(:win)).count
    end
  end
end
