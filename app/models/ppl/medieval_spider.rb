# https://www.ne.jp/asahi/yaston/shogi/syoreikai/3dan/league/3dan_league01.htm

# tp Ppl::MedievalSpider.call(season_key_vo: 1)

module Ppl
  class MedievalSpider < SpiderShared
    class << self
      def accept_range
        "1".."30"
      end
    end

    def default_params
      super.merge(promotion_count_gteq: 2)
    end

    def table_values_array
      @table_values_array ||= doc.at("table").search("tr").collect do |tr|
        tr.search("td").collect { |e| e.text.remove(/\p{Space}+/) }
      end
    end

    def result_key_by_index
      @result_key_by_index ||= doc.at("table").search("tr").drop(1).collect do |tr|
        if v = (tr[:bgcolor] || tr.at("td")[:bgcolor])
          color_tabale.fetch(v)
        end
      end
    end

    def color_tabale
      {
        "#CCCCCC" => "後段点",  # 後段とは異なる
        "#FFCCCC" => "昇段",
        "#FFFFFF" => "不明",    # 意味のない色
      }
    end

    def source_url
      "https://www.ne.jp/asahi/yaston/shogi/syoreikai/3dan/league/3dan_league#{season_key_vo.to_zero_padding_s}.htm"
    end

    def attributes_from(row, index)
      hv = {}

      str = row["師匠・年齢・出身"]
      av = str.split("・")
      hv.update([:mentor, :age, "出身"].zip(av).to_h)

      str = row["成績"]
      av = str.scan(/\d+/)
      hv.update([:win, :lose].zip(av).to_h)

      hv[:ox] = win_lose_normalize(row.values.join)

      hv[:name] = row["氏名"]

      # 「後段点」は「後段」とは異なる
      hv[:result_key] = "維"
      result_key = result_key_by_index[index]
      if result_key == "昇段"
        hv[:result_key] = "昇"
      end

      hv
    end
  end
end
