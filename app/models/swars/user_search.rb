# Swars::User.search 経由で使うこと
#
# grade_keys             # 段級位制限
# user_keys              # ウォーズID制限
# ban_crawled_count_lteq # 垢BANチェック指定回数以下
# ban_crawled_at_lt      # 垢BANチェックの前回が指定日時より過去
# ban_crawl_then_battled # 垢BANチェックのあとで対局があったものに絞る
# limit                  # 件数制限 (2000件=30分)
#
module Swars
  class UserSearch
    def initialize(scope, options = {})
      @scope = scope
      @options = options.to_options
    end

    def call
      s = @scope
      if v = @options[:ids].presence
        s = s.where(id: v)
      end
      if v = @options[:ban_except]
        s = s.ban_except
      end
      if v = @options[:ban_only]
        s = s.ban_only
      end
      if v = @options[:pro_except]
        s = s.pro_except
      end
      if v = @options[:pro_only]
        s = s.pro_only
      end
      if v = @options[:grade_keys].presence
        s = s.grade_eq(v)
      end
      if v = @options[:user_keys].presence
        s = s.where(key: v)
      end
      if v = @options[:ban_crawled_count_lteq].presence
        s = s.ban_crawled_count_lteq(v)
      end
      if v = @options[:ban_crawled_at_lt].presence
        s = s.ban_crawled_at_lt(v)
      end
      if v = @options[:latest_battled_at_lt].presence
        s = s.latest_battled_at_lt(v)
      end
      if v = @options[:ban_crawl_then_battled]
        s = s.ban_crawl_then_battled
      end
      if v = @options[:limit].presence
        s = s.limit(v)
      end
      s
    end
  end
end
