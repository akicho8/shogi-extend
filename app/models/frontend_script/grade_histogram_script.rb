module FrontendScript
  class GradeHistogramScript < ::FrontendScript::Base
    self.script_name = "段級位ヒストグラム"

    def script_body
      counts_hash = Rails.cache.fetch(self.class.name, :expires_in => 1.days) do
        Swars::User.group(:grade).count.inject({}) { |a, (e, count)| a.merge(e.name => count) }
      end

      counts_hash.delete("十段")

      # 6級以下はまとめる
      if true
        start = "6級"
        total = (Swars::GradeInfo[start].code..Swars::GradeInfo.values.last.code).sum do |code|
          counts_hash.delete(Swars::GradeInfo[code].name) || 0
        end
        counts_hash["#{start}以下"] = total
      end

      sdc = StandardDeviation.new(counts_hash.values)

      rows = counts_hash.collect do |name, count|
        {
          name: name,
          count: count,
          deviation_score: sdc.deviation_score(count, -1),
          ratio: sdc.appear_ratio(count),
        }
      end

      if request.format.json?
        return rows
      end

      rows.collect do |e|
        row = {}
        row["段級"]   = e[:name]
        row["割合"]   = "%.3f %%" % [e[:ratio] * 100]
        if Rails.env.development? || params[:vervose]
          row["偏差値"] = "%.2f" % e[:deviation_score]
          row["個数"] = e[:count]
        end
        row
      end
    end
  end
end
