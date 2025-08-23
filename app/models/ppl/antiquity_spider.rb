# https://www.ne.jp/asahi/yaston/shogi/syoreikai/iitoko/seiseki/49nendo_3dan.htm

# tp Ppl::AntiquitySpider.call(season_key_vo: 1)

module Ppl
  class AntiquitySpider < SpiderShared
    class << self
      def accept_range
        "S49".."S62"
      end
    end

    def default_params
      super.merge(promotion_count_gteq: 1)
    end

    # def table_hash_array
    #   header = table_values_array.first
    #   table_values_array.drop(1).take(take_size).collect do |values|
    #     header.zip(values).to_h
    #   end
    # end

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

      hv[:result_key] = "維"
      if md = row.values.join.match(/昇段(?<win>\d+)勝(?<lose>\d+)敗/)
        hv[:result_key] = "昇"
        # 昇段時の勝ち負け数を有効とする場合。ここは、ほぼ 12 勝固定になっている
        hv.update(md.named_captures(symbolize_names: true))
      end

      hv[:ox] = win_lose_normalize(row.values.join)

      # # 正確な勝率を出すため昇段時の12勝は無視して全体を勝ち負け数とする
      # hv[:win]  = hv[:ox].count("o")
      # hv[:lose] = hv[:ox].count("x")

      hv
    end
  end
end
