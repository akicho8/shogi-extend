module BackendScript
  class XconvDashboardScript < ::BackendScript::Base
    include SortMethods

    self.category = "xconv"
    self.script_name = "アニメーション変換"

    def script_body
      xconv_record_hash = {}
      if true
        model = XconvRecord
        s = model.all
        s = s.where(model.arel_table[:created_at].gteq(time_begin))
        records = s.select([
            "DATE(#{DbCop.tz_adjust(:created_at)}) AS created_on",           # 時間→日付変換
            "COUNT(distinct user_id)               AS unique_user_id_count", # ユニーク人数
            "COUNT(*)                              AS count_all",            # 件数
            "COUNT(errored_at is not null or NULL) AS errored_count",        # x
          ].join(", ")).group("created_on")                                  # 日付毎
        # 日付から一発で対応するレコードを求められるようにハッシュ化
        xconv_record_hash = records.inject({}) { |a, e| a.merge(e[:created_on] => e) }
      end

      now = Time.current
      current_length.times.collect do |i|
        current = now.midnight - i.days
        date = current.to_date
        row = {}
        row["日付"]     = h.tag.span(current.to_s(:ymd_j), :class => holiday_sunday_saturday_class(current))
        row["変換数"]   = xconv_record_hash[date]&.count_all
        row["変換人数"] = xconv_record_hash[date]&.unique_user_id_count
        row["失敗"]     = xconv_record_hash[date]&.errored_count
        row
      end
    end

    def time_begin
      current_length.days.ago.midnight
    end

    def current_length
      (params[:length].presence || 30).to_i
    end
  end
end
