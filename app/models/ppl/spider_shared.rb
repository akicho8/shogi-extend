module Ppl
  class SpiderShared
    class << self
      def accept_season_number_range
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
      @params = {
        :take_size => nil,
        :verbose   => Rails.env.development? || Rails.env.staging? || Rails.env.production?,
        :sleep     => (Rails.env.development? || Rails.env.staging? || Rails.env.production?) ? 0.5 : 0,
        :validate  => false,
      }.merge(params)
    end

    def call
      rows = source_rows.collect.with_index do |row, i|
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

      if params[:validate]
        validate!(rows)
      end

      rows
    end

    def validate!(rows)
      unless rows.count { |e| e[:result_key] == "昇" } >= 2
        raise "「昇」が2つ以上ない"
      end
    end

    def source_rows
      raise NotImplementedError, "#{__method__} is not implemented"
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

    def season_number
      params.fetch(:season_number).to_i
    end

    def doc
      @doc ||= Nokogiri::HTML(html_fetch)
    end

    # 当初ここをキャッシュしていたがそれは設計ミス
    # 毎回呼ぶわけではないのでキャッシュする意味がないし大量にメモリを消費するため割に合わない
    def html_fetch
      if Rails.env.test?
        body = Pathname("#{__dir__}/mock/#{self.class.name.demodulize.underscore}.html").read
      else
        if params[:verbose]
          tp({ "期" => season_number, "URL" => source_url, sleep: params[:sleep] })
        end

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
