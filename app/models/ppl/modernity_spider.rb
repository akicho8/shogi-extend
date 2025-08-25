# https://www.shogi.or.jp/match/shoreikai/sandan/31/index.html

# tp Ppl::ModernitySpider.call(season_key_vo: Ppl::SeasonKeyVo["31"])

module Ppl
  class ModernitySpider < Spider
    class << self
      def accept_range?(key)
        key.to_i > MedievalSpider::ACCEPT_RANGE.max
      end
    end

    def default_params
      super.merge(promotion_count_gteq: 0)
    end

    def table_values_array
      @table_values_array ||= yield_self do
        lines = doc.search("table tr").collect do |tr|
          tr.search("td, th").collect { |e| e.text.remove(/\p{Space}+/) }
        end

        # ゴミ行を消す
        lines = lines.reject { |values| values[0].match?(/持時間各|関西/) }
        lines = lines.reject { |values| values[1].match?(/関東/) }

        # 必要な部分だけを抽出する
        head = lines.first
        head[0] = "結果"
        body = lines.drop(1)
        body = body.find_all { |values| values[1].match?(/\A\d+\z/) }

        [head] + body
      end
    end

    def source_url
      "https://www.shogi.or.jp/match/shoreikai/sandan/#{season_key_vo}/index.html"
    end

    def attributes_from(row, _index)
      hv = {}
      hv[:result_key] = row["結果"].presence || "維"
      hv[:name]       = row["氏名"]
      hv[:mentor]     = row["師匠"]
      hv[:win]        = row["勝"]
      hv[:lose]       = row["敗"]
      hv[:age]        = row["年齢"]
      hv[:ox]         = ox_normalize(row.values.join)
      hv
    end
  end
end
