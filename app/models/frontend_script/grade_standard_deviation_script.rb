module FrontendScript
  class GradeStandardDeviationScript < ::FrontendScript::Base
    self.script_name = "段級位の偏差値"

    def script_body
      counts_hash = Rails.cache.fetch(self.class.name, :expires_in => 1.days) do
        Swars::User.group(:grade).count
      end

      sdc = StandardDeviation.new(counts_hash.values)

      rows = counts_hash.collect do |k, v|
        {
          name: k.name,
          count: v,
          sd: sdc.deviation_value(v, -1),
          ratio: sdc.appear_ratio(v),
        }
      end

      if request.format.json?
        return rows
      end

      rows.collect do |e|
        row = {}
        row["段級位"] = e[:grade]
        row["偏差値"] = "%.2f" % e[:sd]
        row["割合"] = "%.2f %%" % (e[:ratio] * 100)
        if Rails.env.development?
          row["個数"] = e[:count]
        end
        row
      end
    end
  end
end
