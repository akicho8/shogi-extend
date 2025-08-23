module Ppl
  class SpiderShared
    class << self
      def accept_range
        raise NotImplementedError, "#{__method__} is not implemented"
      end
    end

    class << self
      def call(...)
        new(...).call
      end
    end

    attr_reader :params

    def initialize(params = {})
      @params = default_params.merge(params)

      season_key_vo
    end

    def default_params
      {
        :take_size            => nil,
        :verbose              => Rails.env.development? || Rails.env.staging? || Rails.env.production?,
        :sleep                => (Rails.env.development? || Rails.env.staging? || Rails.env.production?) ? 0.5 : 0,
        :promotion_count_gteq => 0,
        :mock                 => Rails.env.test?,
      }
    end

    def call
      rows = table_hash_array.collect.with_index do |row, i|
        row = attributes_from(row, i)
        integer_type_column_names.each do |e|
          if v = row[e]
            row[e] = v.to_i
          end
        end
        row.slice(*require_column_names)
      end

      if params[:verbose]
        tp rows
      end

      Rails.logger.info(rows.to_t)

      validate!(rows)

      rows
    end

    def validate!(rows)
      if gteq = params[:promotion_count_gteq]
        unless rows.count { |e| e[:result_key] == "昇" } >= gteq
          raise "「昇」が#{gteq}つ以上ない"
        end
      end
    end

    def table_hash_array
      header = header_normalize(table_values_array.first)
      table_values_array.drop(1).take(take_size).collect do |values|
        header.zip(values).to_h
      end
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

    def source_url
      raise NotImplementedError, "#{__method__} is not implemented"
    end

    def attributes_from(row, index)
      raise NotImplementedError, "#{__method__} is not implemented"
    end

    def require_column_names
      [:result_key, :name, :mentor, :age, :win, :lose, :ox]
    end

    def integer_type_column_names
      [:age, :win, :lose]
    end

    def take_size
      (params[:take_size].presence || 1000).to_i
    end

    def season_key_vo
      @season_key_vo ||= SeasonKeyVo[params.fetch(:season_key_vo)]
    end

    def doc
      @doc ||= Nokogiri::HTML(html_fetch)
    end

    # 当初ここをキャッシュしていたがそれは設計ミス
    # 毎回呼ぶわけではないのでキャッシュする意味がないし大量にメモリを消費するため割に合わない
    def html_fetch
      if params[:verbose]
        tp({ "担当" => self.class.name, "期" => season_key_vo, "URL" => source_url, sleep: params[:sleep] })
      end

      if params[:mock]
        body = Pathname("#{__dir__}/mock/#{self.class.name.demodulize.underscore}.html").read
      else
        sleep(params[:sleep])
        body = URI(source_url).read
      end

      NKF.nkf("-w -Z1", body)
    end

    # 連盟は手動で作っているため勝ち負けの表記がバラバラである
    def win_lose_normalize(str)
      str.scan(/[○□●■]/).join.tr("○□●■", "ooxx")
    end
  end
end
