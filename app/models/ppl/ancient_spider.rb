# https://www.ne.jp/asahi/yaston/shogi/syoreikai/yobi_and_Akumi/league/31nendo_yobi0102.htm

# tp Ppl::AncientSpider.call(season_key_vo: Ppl::SeasonKeyVo["S31前"])

module Ppl
  class AncientSpider < Spider
    class << self
      def accept_range?(key)
        AncientInfo[key]
      end
    end

    def default_params
      super.merge(promotion_count_gteq: 1)
    end

    def source_url
      AncientInfo.fetch(season_key_vo.key).url
    end

    def table_hash_array
      JSON.parse(Pathname(__dir__).join("json/#{season_key_vo}.json").read)
    end

    def attributes_from(row, _index)
      hv = {}

      hv[:name]        = row["氏名"]
      hv[:mentor]      = row["師匠"]
      hv[:age]         = row["年齢"]
      hv[:win]         = row["勝数"]
      hv[:lose]        = row["敗数"]
      hv[:ox]          = row["ox"]
      hv[:ranking_pos] = row["新順位"]

      if row["結果"] == "昇段"
        hv[:result_key] = "昇"
      else
        hv[:result_key] = "維"
      end

      hv
    end

    def validate!(records)
      super

      records.each do |hv|
        if hv[:win].to_i != hv[:ox].to_s.count("o")
          raise hv.inspect
        end
        if hv[:lose].to_i != hv[:ox].to_s.count("x")
          raise hv.inspect
        end
      end
    end
  end
end
