# -*- coding: utf-8 -*-
# == Schema Information ==
#
# ユーザー (users as User)
#
# |------------------------+----------------------------+-------------+---------------------+------+-------|
# | name                   | desc                       | type        | opts                | refs | index |
# |------------------------+----------------------------+-------------+---------------------+------+-------|
# | id                     | ID                         | integer(8)  | NOT NULL PK         |      |       |
# | key                    | ユニークなハッシュ         | string(255) | NOT NULL            |      | A!    |
# | name                   | 名前                       | string(255) | NOT NULL            |      |       |
# | cpu_brain_key          | CPUの思考タイプ            | string(255) |                     |      |       |
# | user_agent             | User agent                 | string(255) | NOT NULL            |      |       |
# | race_key               | 種族                       | string(255) | NOT NULL            |      | F     |
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
# | name_input_at          | Name input at              | datetime    |                     |      |       |
# |------------------------+----------------------------+-------------+---------------------+------+-------|

module Tsl
  class User < ApplicationRecord
    has_many :memberships, dependent: :destroy, inverse_of: :user # 対局時の情報(複数)
    has_many :leagues, through: :memberships                      # 対局(複数)

    before_validation on: :create do
      self.runner_up_count ||= 0
    end

    def name_with_age
      s = ""

      s += name

      if first_age && last_age
        s += "(#{first_age}-#{last_age})"
      end

      case
      when level_up_generation
        s += " #{memberships_count}期抜け"
      when runner_up_count >= 2
        s += " 次点2回で#{memberships_count}期抜け"
      when runner_up_count >= 1
        s += " 在籍#{memberships_count}期 次点あり"
      else
        s += " 在籍#{memberships_count}期"
      end

      # if level_up_generation
      #   s += " (プロ)"
      # end

      s
    end

    # シーズン generation を含まないこれまでの在籍回数
    def seat_count(generation)
      memberships.joins(:league).where(Tsl::League.arel_table[:generation].lt(generation)).count
    end

    # 在籍回数のかわりに表示したい在籍毎の勝数
    def zaiseki_wins(generation)
      g = Tsl::League.arel_table[:generation]
      s = memberships.joins(:league).where(g.lt(generation))
      s.order(g.asc).pluck(:win)
    end
  end
end
