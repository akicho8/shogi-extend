module BackendScript
  class ShortUrlAccessLogScript < ::BackendScript::Base
    self.category = "短縮URL"
    self.script_name = "短縮URL - アクセス数"

    def script_body
      # 日別の問題作成回数を求める
      access_log_hash = {}

      model = ShortUrl::AccessLog
      s = model.all
      s = s.where(model.arel_table[:created_at].gteq(time_begin))
      records = s.select([
                           "DATE(#{MysqlToolkit.column_tokyo_timezone_cast(:created_at)}) AS created_on",
                           "COUNT(*)                              AS count_all",
                         ].join(", ")).group("created_on")
      access_log_hash = records.index_by { it[:created_on] }

      now = Time.current
      current_length.times.collect do |i|
        current = now.beginning_of_day - i.days
        date = current.to_date
        range = "2000-01-01".to_time ... current.tomorrow
        row = {}
        row["日付"]       = h.tag.span(current.to_fs(:ymd_j), :class => holiday_sunday_saturday_class(current))
        row["アクセス数"] = access_log_hash[date]&.count_all
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
