module FrontendScript
  class GradeStandardDeviationScript < ::FrontendScript::Base
    self.script_name = "段級位の偏差値"

    def script_body
      counts_hash = Rails.cache.fetch(self.class.name, :expires_in => 1.days) do
        Swars::User.group(:grade).count.inject({}) { |a, (e, count)| a.merge(e.name => count) }
      end

      sdc = StandardDeviation.new(counts_hash.values)

      rows = counts_hash.collect do |name, count|
        {
          name: name,
          count: count,
          deviation_value: sdc.deviation_value(count, -1),
          ratio: sdc.appear_ratio(count),
        }
      end

      if request.format.json?
        return rows
      end

      rows.collect do |e|
        row = {}
        row["段級"]   = e[:name]
        row["偏差値"] = "%.2f" % e[:deviation_value]
        row["割合"]   = "%.2f %%" % (e[:ratio] * 100)
        if Rails.env.development? || params[:with_count]
          row["個数"] = e[:count]
        end
        row
      end
    end
  end
end
