module FrontendScript
  class AttackRarityScript < ::FrontendScript::Base
    self.script_name = "戦法レアリティ"

    def script_body
      Rails.cache.fetch(self.class.name, :expires_in => 1.days) do
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

        list = counts_hash.values          # => [3, 4, 0]
        total = list.sum                   # => 7
        avg = total.fdiv(list.size)        # => 3.5
        sd = standard_deviation(list, avg) # 標準偏差

        rows = counts_hash.sort_by { |k, v| v }.collect do |name, count|
          deviation = deviation_value(count, avg, sd) # 偏差値
          ratio = count.fdiv(total)            # 割合

          row = {}
          row[:name]      = name
          row[:ratio]     = ratio
          row[:deviation] = deviation
          row[:count]     = count

          row
        end

        if request.format.json?
          return rows
        end

        rows.collect do |row|
          new_row = {}
          new_row["名前"] = h.tag.small(row[:name])
          new_row["出現率"] = "%.3f %%" % (row[:ratio] * 100.0)
          new_row["偏差値"] = "%.3f" % row[:deviation]
          if Rails.env.development? || params[:with_count]
            new_row["個数"] = row[:count]
          end
          new_row
        end
      end
    end

    private

    def tactic_key
      @tactic_key ||= key.underscore.remove("_rarity").to_sym
    end

    # 標準偏差
    def standard_deviation(list, avg)
      v = list.collect { |v| (v - avg) ** 2 }
      v = v.sum
      v = v.fdiv(list.size)
      Math.sqrt(v)
    end

    # 偏差値
    def deviation_value(score, avg, sd)
      ((score - avg) / sd) * 10 + 50
    end
  end
end
