module Swars
  class User
    concern :BanMethods do
      included do
        has_many :ban_crawl_requests, dependent: :destroy     # 垢BAN確認リクエストたち

        scope :ban_only,               -> { where.not(ban_at: nil)                                      } # BANされた人たち
        scope :ban_except,             -> { where(ban_at: nil)                                          } # BANされた人たちを除く
        scope :ban_crawled_count_lteq, -> c { joins(:profile).merge(Profile.ban_crawled_count_lteq(c))  } # 垢BANチェック指定回数以下
        scope :ban_crawled_at_lt,      -> time { joins(:profile).merge(Profile.ban_crawled_at_lt(time)) } # 垢BANチェックの前回が指定日時より過去
        scope :ban_crawl_then_battled, -> { joins(:profile).where(arel_table[:latest_battled_at].gt(Profile.arel_table[:ban_crawled_at])) } # 垢BANチェックしたあとで対局したものたち
      end

      class_methods do
        # ショートカット
        # rails r 'Swars::User.ban_crawl'
        def ban_crawl(...)
          BanCrawler.new(...).call
        end
      end

      # 完全に初期状態に戻す
      def ban_reset
        self.ban_at = nil
        profile.ban_at = nil
        profile.ban_crawled_count = nil
        profile.ban_crawled_at = nil
        save!
      end

      # 保存しない
      def ban_set(state)
        time = Time.current
        value = nil
        if state
          value = time
        end
        self.ban_at = value
        profile.ban_at = value
        profile.ban_crawled_at = time
        profile.ban_crawled_count += 1
        save!
      end

      def ban!
        ban_set(true)
      end

      def ban?
        ban_at
      end
    end
  end
end
