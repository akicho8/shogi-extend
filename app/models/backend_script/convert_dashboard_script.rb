module BackendScript
  class ConvertDashboardScript < ::BackendScript::Base
    include SortMethods

    self.category = "その他"
    self.script_name = "なんでも棋譜変換 KPI"

    def script_body
      # 日別のユニーク対戦者数を求める
      counts_hash = {}
      if true
        model = FreeBattle
        s = model.all
        s = s.where(FreeBattle.arel_table[:kifu_body].not_eq(""))
        s = s.where(FreeBattle.arel_table[:use_key].eq(:adapter))
        s = s.where(model.arel_table[:created_at].gteq(time_begin))
        records = s.select([
            "DATE(#{MysqlToolkit.column_tokyo_timezone_cast(:created_at)}) AS created_on",           # 時間→日付変換
            "COUNT(*)                              AS count_all",            # 利用回数
            "COUNT(distinct user_id)               AS count_au",              # 利用者数
          ].join(", ")).group(:created_on)                                   # 日付毎
        # 日付から一発で対応するレコードを求められるようにハッシュ化
        counts_hash = records.inject({}) { |a, e| a.merge(e[:created_on] => e) }
      end

      now = Time.current.to_date
      current_length.times.collect do |i|
        date = now - i
        row = {}
        row["日付"]     = h.tag.span(date.to_time.to_fs(:ymd_j), :class => holiday_sunday_saturday_class(date))
        row["DAU"]      = counts_hash[date]&.count_au
        row["利用回数"] = counts_hash[date]&.count_all
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
