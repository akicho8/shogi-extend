# ▼削除対象
# rails r Swars::Battle.cleaner_scope
#
# ▼削除実行
# rails r Swars::Battle.cleaner.call
module Swars
  class Battle
    concern :CleanerMethods do
      included do
        scope :old_only, -> expires_in { where(arel_table[:accessed_at].lteq(expires_in.seconds.ago)) }        # 古いもの

        scope :pro_only,    -> { joins(:memberships).merge(Membership.pro_only).distinct   }                       # PROの対局のみ
        scope :pro_except,  -> { where.not(id: Membership.pro_only.select(:battle_id)) }                       # PROの対局を除外する

        scope :ban_only,    -> { joins(:memberships).merge(Membership.ban_only).distinct   }                       # 垢BANになった人との対局のみ
        scope :ban_except,  -> { where.not(id: Membership.ban_only.select(:battle_id)) }                       # 垢BANになった人との対局を除外する

        scope :user_only,   -> user_keys { joins(:memberships).merge(Membership.user_only(user_keys)).distinct } # ユーザーを絞る
        scope :user_except, -> user_keys { where.not(id: Membership.user_only(user_keys).select(:battle_id)) } # ユーザーを省く

        scope :xmode_only,   -> xmode_keys {     where(xmode: Xmode.where(key: xmode_keys)) }                  # 特定の対局モードのみ
        scope :xmode_except, -> xmode_keys { where.not(xmode: Xmode.where(key: xmode_keys)) }                  # 特定の対局モードを除く

        scope :coaching_only,   -> { xmode_only("指導")   }                                                    # 指導対局のみ
        scope :coaching_except, -> { xmode_except("指導") }                                                    # 指導対局を除く

        # 削除対象
        scope :cleaner_scope, -> (options = {}) {
          options = {
          }.merge(options)

          s = all

          # 引数なし
          [
            :coaching_only,
            :coaching_except,
            :pro_only,
            :pro_except,
            :ban_only,
            :ban_except,
          ].each do |m|
            if options[m]
              s = s.public_send(m)
            end
          end

          # 引数あり
          [
            :old_only,
            :user_only,
            :user_except,
            :xmode_only,
            :xmode_except,
          ].each do |m|
            if v = options[m]
              s = s.public_send(m, v)
            end
          end

          s
        }

        # 一般ユーザーの対局は60日後に消す
        scope :drop_scope1, -> (options = {}) {
          options = {
            :xmode_only  => "野良",
            :ban_except  => false,
            :old_only    => Rails.env.local? ? 0.days : 60.days,
            :user_except => Swars::User::Vip.long_time_keep_user_keys + Swars::User::Vip.protected_user_keys,
          }.merge(options)
          cleaner_scope(options)
        }

        # VIPユーザーの対局は120日後に消す
        scope :drop_scope2, -> (options = {}) {
          options = {
            :xmode_only  => "野良",
            :ban_except  => false,
            :old_only    => Rails.env.local? ? 0.days : 120.days,
            :user_only   => Swars::User::Vip.long_time_keep_user_keys, # こちらに含まれていても
            :user_except => Swars::User::Vip.protected_user_keys,      # さらにこちらで除外される
          }.merge(options)
          cleaner_scope(options)
        }
      end

      class_methods do
        # rails r 'Swars::Battle.cleaner1.call'
        def cleaner1(options = {})
          drop_scope1(options).cleaner({subject: "一般"}.merge(options))
        end

        # rails r 'Swars::Battle.cleaner2.call'
        def cleaner2(options = {})
          drop_scope2(options).cleaner({subject: "VIP"}.merge(options))
        end
      end
    end
  end
end
