module BackendScript
  class SwarsDashboardScript < ::BackendScript::Base
    include SortMethods

    self.category = "swars"
    self.script_name = "棋譜検索 ダッシュボード"

    def script_body
      # if Rails.env.production?
      #   return "productionではMySQLが死ぬので実行禁止"
      # end

      # # 日別の履歴数を求める
      # answer_log_hash = {}
      # if true
      #   model = Swars::AnswerLog
      #   s = model.all
      #   s = s.where(model.arel_table[:created_at].gteq(time_begin))
      #   records = s.select([
      #       "DATE(#{MysqlToolkit.column_tokyo_timezone_cast(:created_at)}) AS created_on",                          # 時間→日付変換
      #       "COUNT(*) AS count_all",                                                        # 履歴数
      #       "COUNT(answer_kind_id = #{Swars::AnswerKind.fetch(:correct).id} or NULL) AS correct_count", # o
      #       "COUNT(answer_kind_id = #{Swars::AnswerKind.fetch(:mistake).id} or NULL) AS mistake_count", # x
      #     ].join(", ")).group("created_on")                                  # 日付毎
      #   # 日付から一発で対応するレコードを求められるようにハッシュ化
      #   answer_log_hash = records.inject({}) { |a, e| a.merge(e[:created_on] => e) }
      # end

      # 日別の問題作成回数を求める
      battle_hash = {}
      if Rails.env.production?
      else
        model = Swars::Battle
        s = model.all
        s = s.where(model.arel_table[:created_at].gteq(time_begin))
        records = s.select([
            "DATE(#{MysqlToolkit.column_tokyo_timezone_cast(:created_at)}) AS created_on",           # 時間→日付変換
            "COUNT(*)                              AS count_all",            # 新規問題作成数
          ].join(", ")).group("created_on")                                  # 日付毎
        # 日付から一発で対応するレコードを求められるようにハッシュ化
        battle_hash = records.inject({}) { |a, e| a.merge(e[:created_on] => e) }
      end

      # 日別の問題作成回数を求める
      user_hash = {}
      if true
        model = Swars::User
        s = model.all
        s = s.where(model.arel_table[:created_at].gteq(time_begin))
        records = s.select([
            "DATE(#{MysqlToolkit.column_tokyo_timezone_cast(:created_at)}) AS created_on",           # 時間→日付変換
            "COUNT(*)                              AS count_all",            # 新規問題作成数
          ].join(", ")).group("created_on")                                  # 日付毎
        # 日付から一発で対応するレコードを求められるようにハッシュ化
        user_hash = records.inject({}) { |a, e| a.merge(e[:created_on] => e) }
      end

      # 検索数
      search_hash = {}
      if true
        model = Swars::SearchLog
        s = model.all
        s = s.where(model.arel_table[:created_at].gteq(time_begin))
        records = s.select([
            "DATE(#{MysqlToolkit.column_tokyo_timezone_cast(:created_at)}) AS created_on",           # 時間→日付変換
            "COUNT(distinct user_id)               AS unique_user_id_count", # ユニーク問題作成者数
            "COUNT(*)                              AS count_all",            # 新規問題作成数
          ].join(", ")).group("created_on")                                  # 日付毎
        # 日付から一発で対応するレコードを求められるようにハッシュ化
        search_hash = records.inject({}) { |a, e| a.merge(e[:created_on] => e) }
      end

      # 古い棋譜の補完
      crawl_reservation_hash = {}
      if true
        model = Swars::CrawlReservation
        s = model.all
        s = s.where(model.arel_table[:created_at].gteq(time_begin))
        records = s.select([
            "DATE(#{MysqlToolkit.column_tokyo_timezone_cast(:created_at)}) AS created_on",           # 時間→日付変換
            "COUNT(distinct user_id)               AS unique_user_id_count", # ユニーク人数
            "COUNT(*)                              AS count_all",            # 件数
          ].join(", ")).group("created_on")                                  # 日付毎
        # 日付から一発で対応するレコードを求められるようにハッシュ化
        crawl_reservation_hash = records.inject({}) { |a, e| a.merge(e[:created_on] => e) }
      end

      # # 日別の問題集作成回数を求める
      # book_hash = {}
      # if true
      #   model = Swars::Book
      #   s = model.all
      #   s = s.where(model.arel_table[:created_at].gteq(time_begin))
      #   records = s.select([
      #       "DATE(#{MysqlToolkit.column_tokyo_timezone_cast(:created_at)}) AS created_on",           # 時間→日付変換
      #       "COUNT(distinct user_id)               AS unique_user_id_count", # ユニーク問題作成者数
      #       "COUNT(*)                              AS count_all",            # 新規問題作成数
      #     ].join(", ")).group("created_on")                                  # 日付毎
      #   # 日付から一発で対応するレコードを求められるようにハッシュ化
      #   book_hash = records.inject({}) { |a, e| a.merge(e[:created_on] => e) }
      # end

      now = Time.current
      current_length.times.collect do |i|
        current = now.beginning_of_day - i.days
        date = current.to_date
        range = "2000-01-01".to_time ... current.tomorrow
        row = {}
        row["日付"]           = h.tag.span(current.to_fs(:ymd_j), :class => holiday_sunday_saturday_class(current))
        row["新規バトル数"]   = battle_hash[date]&.count_all
        row["新規ユーザー数"] = user_hash[date]&.count_all
        row["検索数"]         = search_hash[date]&.count_all
        row["検索人数"]       = search_hash[date]&.unique_user_id_count
        row["棋譜補完"]       = crawl_reservation_hash[date]&.count_all
        row["棋譜補完人数"]   = crawl_reservation_hash[date]&.unique_user_id_count
        # row["バトル総数"]     = Swars::Battle.where(created_at: range).count
        # row["削除予定数"]     = Swars::Battle.where(created_at: range).cleanup_scope.count
        # row["対局時情報総数"] = Swars::Membership.where(created_at: range).count
        row
      end
    end

    def time_begin
      current_length.days.ago.beginning_of_day
    end

    def current_length
      (params[:length].presence || 30).to_i
    end
  end
end
