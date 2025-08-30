# https://www.ne.jp/asahi/yaston/shogi/syoreikai/3dan/league/3dan_league01.htm

# tp Ppl::MedievalSpider.call(season_key_vo: Ppl::SeasonKeyVo["1"])

module Ppl
  class MedievalSpider < Spider
    ACCEPT_RANGE = 1..30

    class << self
      def accept_range?(key)
        if key.match?(/\A\d+\z/)
          ACCEPT_RANGE.cover?(key.to_i)
        end
      end
    end

    def default_params
      super.merge(promotion_count_gteq: 2)
    end

    def attributes_from(row, index)
      hv = {}

      str = row["師匠・年齢・出身"]
      av = str.split("・")
      hv.update([:mentor, :age, "出身"].zip(av).to_h)

      str = row["成績"]
      av = str.scan(/\d+/)
      hv.update([:win, :lose].zip(av).to_h)

      hv[:ox] = ox_normalize(row.values.join)

      hv[:name] = row["氏名"]

      hv[:ranking_pos] = row["順位2"] # 同じカラムが2つあるため後者側の順位を見る

      # 「後段点」は「後段」とは異なる
      hv[:result_key] = "維持"
      if result_key_by_index[index] == "昇段"
        hv[:result_key] = "昇段"
      end

      hv
    end

    def table_values_array
      @table_values_array ||= doc.at("table").search("tr").collect do |tr|
        tr.search("td").collect { |e| e.text.remove(/\p{Space}+/) }
      end
    end

    def source_url
      "https://www.ne.jp/asahi/yaston/shogi/syoreikai/3dan/league/3dan_league#{season_key_vo.to_zero_padding_s}.htm"
    end

    ################################################################################

    def result_key_by_index
      @result_key_by_index ||= doc.at("table").search("tr").drop(1).collect do |tr|
        if v = (tr[:bgcolor] || tr.at("td")[:bgcolor])
          result_by_color.fetch(v)
        end
      end
    end

    def result_by_color
      {
        "#CCCCCC" => "後段点",  # 後段とは異なる
        "#FFCCCC" => "昇段",
        "#FFFFFF" => "不明",    # 意味のない色
      }
    end

    ################################################################################
  end
end
