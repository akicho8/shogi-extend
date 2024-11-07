module Swars
  class User
    concern :GeneralScopeMethods do
      included do
        scope :recently_only, -> { where.not(last_reception_at: nil).order(last_reception_at: :desc) } # 最近使ってくれた人たち順
        scope :regular_only,  -> { order(search_logs_count: :desc)                                   } # 検索回数が多い人たち順
        scope :great_only,    -> { joins(:grade).order(Grade.arel_table[:priority].asc)              } # 段級位が高い人たち順

        scope :vip_only,   -> { where(key: Vip.auto_crawl_user_keys) }                                 # VIPユーザーのみ
        scope :vip_except, -> { where.not(key: Vip.auto_crawl_user_keys) }                             # VIPユーザーを除く

        scope :momentum_only, -> **options { where(id: SearchLog.momentum_user_ids(**options)) }     # 最近たくさん検索されたユーザーたち
      end
    end
  end
end
