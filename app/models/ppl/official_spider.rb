# https://www.shogi.or.jp/match/shoreikai/sandan/31/index.html

# tp Ppl::OfficialSpider.call(season_number: 31)

module Ppl
  class OfficialSpider < SpiderShared
    class << self
      def accept_season_number_range
        31..
      end
    end

    def source_rows
      doc.search("tbody tr").take(take_size).collect do |tr|
        values = tr.search("td").collect { |e| e.text.remove(/\p{Space}+/) }
        row = column_names.zip(values).to_h
        row[:ox] = win_lose_normalize(values.join)
        row
      end
    end

    def source_url
      "https://www.shogi.or.jp/match/shoreikai/sandan/#{season_number}/index.html"
    end

    def attributes_from(row, index)
      hv = row.dup
      hv[:result_key] = hv[:result_key].presence || "維"
      hv
    end

    # 昔と今でフォーマットが異なる
    # ・昔 https://www.shogi.or.jp/match/shoreikai/sandan/28/index.html
    # ・今 https://www.shogi.or.jp/match/shoreikai/sandan/66/index.html
    #
    # 2回目の次点が「昇」マークになっている問題
    # 次点についても表記が統一されておらず次点の2回目では「次」と表示せずに「昇」としている
    # 例: https://www.shogi.or.jp/match/shoreikai/sandan/72/index.html
    # 「柵木幹太」は次点2回目で権利を取得しただけにもかかわらず「昇」のマークを入れてしまっているため、
    # 次点2回目なのか2位以内に入ったことで昇段なのか判断できない
    def column_names
      [:result_key, :_start_pos, :name, :mentor, :age, :win, :lose]
    end
  end
end
