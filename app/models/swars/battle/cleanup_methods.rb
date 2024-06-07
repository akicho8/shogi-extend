# ▼削除対象
# rails r Swars::Battle.cleanup_scope
#
# ▼削除実行
# rails r Swars::Battle.cleanup
module Swars
  class Battle
    concern :CleanupMethods do
      included do
        scope :old_only,          -> expires_in { where(arel_table[:accessed_at].lteq(expires_in.seconds.ago)) } # 古いもの
        scope :coaching_except,   -> { where.not(xmode: Xmode.fetch("指導"))       }                             # 指導対局を除く
        scope :pro_except,        -> { where.not(id: Grade.fetch("十段").battles)  }                             # 十段の対局を除く

        scope :user_except,       -> user_keys { eager_load(memberships: :user).merge(User.where.not(user_key: user_keys)) } # ユーザーを省く
        scope :user_only,         -> user_keys { eager_load(memberships: :user).merge(User.where(user_key: user_keys))     } # ユーザーを絞る

        scope :ban_only,    -> { eager_load(memberships: :user).merge(User.ban_only)   } # 垢BANになった人との対局のみ
        scope :ban_except,  -> { eager_load(memberships: :user).merge(User.ban_except) } # 垢BANになった人との対局を除外する

        # scope :ban_only,    -> { eager_load(:memberships).merge(Membership.where(user: User.ban_only))   } # 垢BANになった人との対局のみ
        # scope :ban_except,  -> { eager_load(:memberships).merge(Membership.where(user: User.ban_except)) } # 垢BANになった人との対局を除外する

        # scope :ban_only,    -> { where(id: joins(:memberships => :user).merge(User.ban_only))   }
        # scope :ban_except,  -> { where(id: joins(:memberships => :user).merge(User.ban_except)) }

        # 削除対象
        scope :cleanup_scope, -> (options = {}) {
          options = {
            :coaching_except => true,
            :pro_except      => true,
            :ban_except      => true,
          }.merge(options)

          s = all                                                    # 全員
          if options[:expires_in]
            s = s.old_only(options[:expires_in])                     # expires_in の期間アクセスされなかったもの
          end
          if options[:coaching_except]
            s = s.coaching_except                                      # 指導対局を除外する
          end
          if options[:pro_except]
            s = s.pro_except                                        # 十段の対局を除外する
          end
          if options[:user_except]
            s = s.user_except(options[:user_except])
          end
          if options[:user_only]
            s = s.user_only(options[:user_only])
          end
          if options[:ban_except]
            s = s.ban_except
          end
          if options[:ban_only]
            s = s.ban_only
          end
          s
        }
      end

      class_methods do
        # 参照されていないレコードを消していく
        # rails r 'Swars::Battle.cleanup1'
        def cleanup1(options = {})
          options = {
            :expires_in => Rails.env.production? ? 50.days : 0.days,
            :time_limit => Rails.env.production? ? 4.hours : nil,  # 最大処理時間(朝2時に実行したら6時には必ず終了させる)
            :user_except => Rails.env.local? ? ["DevUser1"] : Rails.application.credentials[:battle_cleanup_except_users],
          }.merge(options)

          Cleanup.new(options.merge(scope: cleanup_scope(options)))
        end

        # rails r 'Swars::Battle.cleanup2'
        def cleanup2(options = {})
          options = {
            :expires_in => Rails.env.production? ? 100.days : 0.days,
            :time_limit => Rails.env.production? ? 4.hours : nil,  # 最大処理時間(朝2時に実行したら6時には必ず終了させる)
            :user_only  => Rails.application.credentials[:battle_cleanup_except_users],
          }.merge(options)

          Cleanup.new(options.merge(scope: cleanup_scope(options)))
        end
      end
    end
  end
end
