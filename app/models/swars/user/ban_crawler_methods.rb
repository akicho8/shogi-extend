# ▼削除対象
# rails r Swars::User.ban_crawler_scope
#
# ▼削除実行
# rails r Swars::User.ban_crawler
module Swars
  class User
    concern :BanCrawlerMethods do
      included do
        #   # 削除対象外のウォーズIDs
        #   cattr_accessor(:skip_users) do
        #     if Rails.env.production? || Rails.env.staging?
        #       Rails.application.credentials[:battles_destroy_skip_users]
        #     else
        #       ["DevUser1"]
        #     end
        #   end
        #

        scope :ban_only,   -> { where.not(ban_at: nil) }                # BANされた人たち
        scope :ban_except, -> { where(ban_at: nil)     }                # BANされた人たちを除く
        scope :pro_except, -> { where.not(grade: Grade.fetch("十段")) } # プロを除く

        # BAN確認対象者
        scope :ban_crawler_scope, -> (options = {}) {
          options = {
            # :expires_in => 0.days,
            # :skip_users => skip_users,
          }.merge(options)

          s = all                                         # 全員
          s = s.ban_except                                # BANされた人たちを除く
          s = s.pro_except                                # プロを除く

          # if Rails.env.local?
          # else
          #   s = s.ban_except
          # end
          if v = options[:grade]
            s = s.where(grade: Grade.fetch(v))
          end
          if v = options[:limit]
            s = s.limit(v)
          end

          # s = s.old_only(options[:expires_in])            # expires_in の期間アクセスされなかったもの
          # s = s.coaching_except                           # 指導対局を除外する
          # s = s.expert_except                             # 十段の対局を除外する
          # s = s.special_user_own_record_except(options[:skip_users]) # 特定のユーザーを除外する
          s
        }

        #   scope :old_only,        -> expires_in { where(arel_table[:accessed_at].lteq(expires_in.seconds.ago)) } # 古いもの
        #   scope :coaching_except, -> { where.not(xmode: Xmode.fetch("指導"))       }                             # 指導対局を除く
        #   scope :expert_except,   -> { where.not(id: Grade.fetch("十段").battles)  }                             # 十段の対局を除く
        #
        #   # 特定の利用者の対局を除く
        #   scope :special_user_own_record_except, proc { |user_keys|
        #     users = User.where(user_key: user_keys)
        #     # FIXME: Rails 6.1 からは User.xxx は scope を継承されなくなるので unscoped は不要
        #     if true
        #       skip_battles = User.unscoped.joins(memberships: :user).merge(Membership.where(user: users)).distinct # JOIN版
        #     else
        #       skip_battles = User.unscoped.where(id: Membership.where(user: users).pluck(:battle_id).uniq) # JOIN使わない版
        #     end
        #     where.not(id: skip_battles)
        #   }
      end

      class_methods do
        # 垢BAN情報を更新する
        # rails r 'Swars::User.ban_crawler(time_limit: nil)'
        def ban_crawler(...)
          BanCrawler.new(...).call
        end
      end
    end
  end
end
