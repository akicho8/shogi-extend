# ▼削除対象
# rails r Swars::Battle.cleanup_scope
#
# ▼削除実行
# rails r Swars::Battle.cleanup
module Swars
  class Battle
    concern :CleanupMethods do
      included do
        # 削除対象外のウォーズIDs
        cattr_accessor(:skip_users) do
          if Rails.env.production? || Rails.env.staging?
            Rails.application.credentials[:battles_destroy_skip_users]
          else
            ["DevUser1"]
          end
        end

        # 削除対象
        scope :cleanup_scope, -> (options = {}) {
          options = {
            :expires_in => 45.days,
            :skip_users => skip_users,
          }.merge(options)

          s = all                                         # 全員
          s = s.old_only(options[:expires_in])            # expires_in の期間アクセスされなかったもの
          s = s.coaching_except                           # 指導対局を除外する
          s = s.expert_except                             # 十段の対局を除外する
          s = s.special_user_own_record_except(options[:skip_users]) # 特定のユーザーを除外する
          s
        }

        scope :old_only,        -> expires_in { where(arel_table[:accessed_at].lteq(expires_in.seconds.ago)) } # 古いもの
        scope :coaching_except, -> { where.not(xmode: Xmode.fetch("指導"))       }                             # 指導対局を除く
        scope :expert_except,   -> { where.not(id: Grade.fetch("十段").battles)  }                             # 十段の対局を除く

        # 特定の利用者の対局を除く
        scope :special_user_own_record_except, proc { |user_keys|
          users = User.where(user_key: user_keys)
          # FIXME: Rails 6.1 からは Battle.xxx は scope を継承されなくなるので unscoped は不要
          if true
            skip_battles = Battle.unscoped.joins(memberships: :user).merge(Membership.where(user: users)).distinct # JOIN版
          else
            skip_battles = Battle.unscoped.where(id: Membership.where(user: users).pluck(:battle_id).uniq) # JOIN使わない版
          end
          where.not(id: skip_battles)
        }
      end

      class_methods do
        # 参照されていないレコードを消していく
        # rails r 'Swars::Battle.cleanup(time_limit: nil)'
        def cleanup(options = {})
          CleanupRunner.new(cleanup_scope(options), options).perform
        end
      end
    end
  end
end
