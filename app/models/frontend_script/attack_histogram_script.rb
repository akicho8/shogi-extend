module FrontendScript
  class AttackHistogramScript < ::FrontendScript::Base
    self.script_name = "戦法ヒストグラム"
    self.visibility_hidden = true

    def script_body
      ogp_params_set

      counts_hash = Rails.cache.fetch(self.class.name, :expires_in => 1.days) do
        # DBに入っているものを取得
        tags = Swars::Membership.tag_counts_on("#{tactic_key}_tags")
        counts_hash = tags.inject({}) { |a, e| a.merge(e.name => e.count) }    # => { "棒銀" => 3, "棒金" => 4 }

        # タグにない戦法も抽出するため
        counts_hash = Bioshogi::TacticInfo.fetch(tactic_key).model.inject({}) { |a, e| a.merge(e.name => counts_hash[e.name] || 0) } # => { "棒銀" => 3, "棒金" => 4, "風車" => 0 }

        # いらんタグを消す
        if Rails.env.production? || Rails.env.staging? || Rails.env.test?
          Array(TagMod.reject_tag_keys[tactic_key]).each do |e|
            counts_hash.delete(e.to_s)
          end
        end

        counts_hash
      end

      sdc = StandardDeviation.new(counts_hash.values)

      rows = counts_hash.sort_by { |name, count| count }.collect do |name, count|
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
        row["名前"]   = h.tag.span(e[:name], :class => "is-size-7")
        row["出現率"] = "%.3f %%" % (e[:ratio] * 100.0)
        if Rails.env.development? || params[:vervose]
          row["偏差値"] = "%.3f" % e[:deviation_score]
          row["個数"] = e[:count]
        end
        row
      end
    end

    private

    def tactic_key
      @tactic_key ||= key.underscore.remove("_histogram").to_sym
    end
  end
end
