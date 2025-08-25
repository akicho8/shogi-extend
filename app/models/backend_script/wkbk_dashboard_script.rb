module BackendScript
  class WkbkDashboardScript < ::BackendScript::Base
    include SortMethods

    self.category = "wkbk"
    self.script_name = "将棋ドリル KPI"

    def script_body
      # 日別の履歴数を求める
      answer_log_hash = {}
      if true
        model = Wkbk::AnswerLog
        s = model.all
        s = s.where(model.arel_table[:created_at].gteq(time_begin))
        records = s.select([
            "DATE(#{MysqlToolkit.column_tokyo_timezone_cast(:created_at)}) AS created_on",                          # 時間→日付変換
            "COUNT(*) AS count_all",                                                        # 履歴数
            "COUNT(answer_kind_id = #{Wkbk::AnswerKind.fetch(:correct).id} or NULL) AS correct_count", # o
            "COUNT(answer_kind_id = #{Wkbk::AnswerKind.fetch(:mistake).id} or NULL) AS mistake_count", # x
          ].join(", ")).group("created_on")                                  # 日付毎
        # 日付から一発で対応するレコードを求められるようにハッシュ化
        answer_log_hash = records.index_by { it[:created_on] }
      end

      # 日別の問題作成回数を求める
      article_hash = {}
      if true
        model = Wkbk::Article
        s = model.all
        s = s.where(model.arel_table[:created_at].gteq(time_begin))
        records = s.select([
            "DATE(#{MysqlToolkit.column_tokyo_timezone_cast(:created_at)}) AS created_on",           # 時間→日付変換
            "COUNT(distinct user_id)               AS unique_user_id_count", # ユニーク問題作成者数
            "COUNT(*)                              AS count_all",            # 新規問題作成数
          ].join(", ")).group("created_on")                                  # 日付毎
        # 日付から一発で対応するレコードを求められるようにハッシュ化
        article_hash = records.index_by { it[:created_on] }
      end

      # 日別の問題集作成回数を求める
      book_hash = {}
      if true
        model = Wkbk::Book
        s = model.all
        s = s.where(model.arel_table[:created_at].gteq(time_begin))
        records = s.select([
            "DATE(#{MysqlToolkit.column_tokyo_timezone_cast(:created_at)}) AS created_on",           # 時間→日付変換
            "COUNT(distinct user_id)               AS unique_user_id_count", # ユニーク問題作成者数
            "COUNT(*)                              AS count_all",            # 新規問題作成数
          ].join(", ")).group("created_on")                                  # 日付毎
        # 日付から一発で対応するレコードを求められるようにハッシュ化
        book_hash = records.index_by { it[:created_on] }
      end

      now = Time.current.to_date
      current_length.times.collect do |i|
        date = now - i
        row = {}
        row["日付"]           = h.tag.span(date.to_time.to_fs(:ymd_j), :class => holiday_sunday_saturday_class(date))
        row["o"]              = answer_log_hash[date]&.correct_count
        row["x"]              = answer_log_hash[date]&.mistake_count
        row["ox"]             = answer_log_hash[date]&.count_all
        row["問題作成回数"]   = article_hash[date]&.count_all
        row["問題作成人数"]   = article_hash[date]&.unique_user_id_count
        row["問題集作成回数"] = book_hash[date]&.count_all
        row["問題集作成人数"] = book_hash[date]&.unique_user_id_count
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
