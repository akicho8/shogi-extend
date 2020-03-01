module FrontScript
  class AttackRarityScript < Base
    self.script_name = "戦法レアリティ"

    def script_body
      Rails.cache.fetch(self.class.name, :expires_in => 1.days) do
        # DBに入っているものを取得
        tags = Swars::Membership.tag_counts_on("#{tactic_key}_tags")
        counts_hash = tags.inject({}) { |a, e| a.merge(e.name => e.count) }    # => { "棒銀" => 3, "棒金" => 4 }

        # タグにない戦法も抽出するため
        counts_hash = Bioshogi::TacticInfo.fetch(tactic_key).model.inject({}) { |a, e| a.merge(e.name => counts_hash[e.name] || 0) } # => { "棒銀" => 3, "棒金" => 4, "風車" => 0 }

        list = counts_hash.values          # => [3, 4, 0]
        total = list.sum                   # => 7
        avg = total.fdiv(list.size)        # => 3.5
        sd = standard_deviation(list, avg) # 標準偏差

        counts_hash.sort_by { |k, v| v }.collect do |name, count|
          dv = deviation_value(count, avg, sd) # 偏差値
          ratio = count.fdiv(total) * 100      # 割合

          row = {}
          row["名前"] = name
          row["レア度"] = "⭐" * rarity(ratio)
          row["割合"] = "%.3f %%" % ratio
          row["偏差値"] = "%.3f" % dv

          if Rails.env.development? || params[:with_count]
            row["個数"] = count
          end

          row
        end
      end
    end

    private

    def tactic_key
      @tactic_key ||= key.underscore.remove("_rarity")
    end

    # レア度
    def rarity(r)
      case
      when r < 0.006
        5
      when r < 0.03
        4
      when r < 0.20
        3
      when r < 2.0
        2
      else
        1
      end
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
      (((score - avg) / sd) * 10 + 50)
    end
  end
end
