module FrontendScript
  class GradeHistogramScript < ::FrontendScript::Base
    self.script_name = "将棋ウォーズ段級位分布"

    def script_body
      ogp_params_set

      counts_hash = Rails.cache.fetch(self.class.name, :expires_in => 1.days) do
        Swars::User.group(:grade).count.inject({}) { |a, (e, count)| a.merge(e.name => count) }
      end

      counts_hash.delete("十段")

      # まとめるんじゃなくて削除する
      if true
        range = "10級".."30級"
        (Swars::GradeInfo[range.first].code..Swars::GradeInfo[range.last].code).each do |code|
          grade_info = Swars::GradeInfo[code]
          counts_hash.delete(grade_info.name)
        end
      end

      # 6級以下はまとめる
      if false
        start = "10級"
        total = (Swars::GradeInfo[start].code..Swars::GradeInfo.values.last.code).sum do |code|
          counts_hash.delete(Swars::GradeInfo[code].name) || 0
        end
        counts_hash["#{start}以下"] = total
      end

      sdc = StandardDeviation.new(counts_hash.values)

      rows = counts_hash.reverse_each.collect do |name, count|
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

      data = {
        labels: rows.collect { |e| e[:name][0] },
        datasets: [
          {
            label: nil,
            data: rows.collect { |e| e[:ratio] },
          },
        ],
      }

      info = {
        data: data,
        scales_yAxes_ticks: {
        },
      }

      out = ""
      out += h.javascript_tag(%(document.addEventListener('DOMContentLoaded', () => { new Vue({}).$mount("#app") })))
      out += %(<div id="app"><custom_chart :info='#{info.to_json}' /></div>)

      if rows.present?
        out += rows.reverse.collect { |e|
          row = {}
          row["段級"]   = e[:name]
          row["割合"]   = "%.2f %%" % [e[:ratio] * 100]
          if Rails.env.development? || params[:vervose]
            row["偏差値"] = "%.2f" % e[:deviation_score]
            row["人数"] = e[:count]
          end
          row
        }.to_html
      end

      out
    end
  end
end
