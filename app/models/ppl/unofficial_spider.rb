# https://www.ne.jp/asahi/yaston/shogi/syoreikai/3dan/league/3dan_league01.htm

# tp Ppl::UnofficialSpider.call(season_number: 1)

module Ppl
  class UnofficialSpider < SpiderShared
    class << self
      def accept_season_number_range
        1..30
      end
    end

    def source_rows
      header = header_normalize(source_lines.first)
      source_lines.drop(1).take(take_size).collect do |values|
        header.zip(values).to_h
      end
    end

    def source_lines
      @source_lines ||= doc.at("table").search("tr").collect do |tr|
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
      zero_padding_number = "%02d" % season_number
      "https://www.ne.jp/asahi/yaston/shogi/syoreikai/3dan/league/3dan_league#{zero_padding_number}.htm"
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

    # header_normalize(["a", "b", "a", "a"]) → ["a", "b", "a2", "a3"]
    def header_normalize(header)
      counts = Hash.new(0)
      av = []
      header.collect do |str|
        counts[str] += 1
        if counts[str] >= 2
          str = [str, counts[str]].join
        end
        str
      end
    end
  end
end
