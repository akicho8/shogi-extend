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

    has_many :memberships, dependent: :destroy # 対局時の情報(複数)
    has_many :battles, through: :memberships   # 対局(複数)

    has_many :op_memberships, class_name: "Membership", foreign_key: "op_user_id", dependent: :destroy # (対戦相手の)対局時の情報(複数)

    belongs_to :grade                          # すべてのモードのなかで一番よい段級位
    has_many :search_logs, dependent: :destroy # 明示的に取り込んだ日時の記録

    before_validation do
      if Rails.env.development? || Rails.env.test?
        self.user_key ||= "#{self.class.name.demodulize.underscore}#{self.class.count.next}"
      end
      self.user_key ||= SecureRandom.hex

      if Rails.env.development? || Rails.env.test?
        if Grade.count.zero?
          Swars.setup
        end
      end

      self.grade ||= Grade.last

      # Grade が下がらないようにする
      # 例えば10分メインの人が3分を1回やっただけで30級に戻らないようにする
      if will_save_change_to_attribute?(:grade_id)
        ov, nv = attribute_change_to_be_saved(:grade_id)
        if ov && nv
          if Grade.find(ov).priority < Grade.find(nv).priority
            self.grade_id = ov
          end
        end
      end
    end

    with_options presence: true do
      validates :user_key
    end

    with_options allow_blank: true do
      validates :user_key, uniqueness: { case_sensitive: true }
    end

    def to_param
      user_key
    end

    def name_with_grade
      "#{user_key} #{grade.name}"
    end

    concerning :UserInfoMod do
      def user_info(params = {})
        UserInfo.new(self, params)
      end
    end

    concerning :ScopeMethods do
      included do
        scope :recently_only, -> { where.not(last_reception_at: nil).order(last_reception_at: :desc) }                     # よく使ってくれる人
        scope :regular_only, -> { order(search_logs_count: :desc) }                                                        # よく使ってくれる人
        scope :great_only, -> { joins(:grade).order(Swars::Grade.arel_table[:priority].desc).order(:updated_at => :desc) } # すごい人
      end
    end
  end
end
