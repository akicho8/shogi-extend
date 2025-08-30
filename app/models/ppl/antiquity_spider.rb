# https://www.ne.jp/asahi/yaston/shogi/syoreikai/iitoko/seiseki/49nendo_3dan.htm

# tp Ppl::AntiquitySpider.call(season_key_vo: Ppl::SeasonKeyVo["S49"])

module Ppl
  class AntiquitySpider < Spider
    class << self
      def accept_range?(key)
        if md = key.match(/\AS(?<number>\d+)\z/)
          (49..62).cover?(md[:number].to_i)
        end
      end
    end

    def default_params
      super.merge(promotion_count_gteq: 1)
    end

    def table_values_array
      @table_values_array ||= yield_self do
        lines = doc.search("table tr").collect do |tr|
          tr.search("td").collect { |e| e.text.remove(/\p{Space}+/) }
        end

        # 上のリンクを削除する
        lines = lines.reject { |tds| tds.first.match?(/昭和.*年度/) }

        # テーブルが2つ合わさっているのでヘッダーを一つにする
        head = lines.take(1)
        body = lines.drop(1)
        body = body.reject { |tds| tds.first == "氏名" }
        head + body
      end
    end

    def source_url
      "https://www.ne.jp/asahi/yaston/shogi/syoreikai/iitoko/seiseki/#{season_key_vo.to_i}nendo_3dan.htm"
    end

    def attributes_from(row, _index)
      hv = {}

      hv[:name] = row["氏名"]

      str = row["師匠・年齢・出身"]
      av = str.split("・")
      hv.update([:mentor, :age, "出身"].zip(av).to_h)

      one_line = row.values.join
      one_line = one_line.remove(/昇段の一番を逃した後\d+連勝での/) # https://www.ne.jp/asahi/yaston/shogi/syoreikai/iitoko/seiseki/61nendo_3dan.htm

      hv[:result_key] = "維持"
      if md = one_line.match(/昇段(?<win>\d+)勝(?<lose>\d+)敗/)
        hv[:result_key] = "昇段"
        hv.update(md.named_captures(symbolize_names: true))
      elsif md = one_line.match(/昇段(?<win>\d+)連勝/)
        hv[:result_key] = "昇段"
        hv[:win] = md[:win]
        hv[:lose] = 0
      elsif one_line.match?(/退会/)
        hv[:result_key] = "退会"
      end

      hv[:ox] = ox_normalize(one_line)

      # 現行の三段リーグは半年あたりの勝数なのに対してこちらは一年間なのでそのまま反映してしまうと「最勝」でソートする意味がなくなってしまう
      # hv[:win]  = hv[:ox].count("o")
      # hv[:lose] = hv[:ox].count("x")

      hv
    end
  end
end
