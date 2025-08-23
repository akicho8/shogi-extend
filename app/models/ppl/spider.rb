module Ppl
  class Spider
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

    def call
      records
    end

    def records
      @records ||= yield_self do
        records = table_hash_array.collect.with_index do |record, i|
          record = attributes_from(record, i)
          integer_type_column_names.each do |e|
            if v = record[e]
              record[e] = v.to_i
            end
          end
          if params[:slice]
            record = record.slice(*require_column_names)
          end
          record
        end

        if params[:verbose]
          tp records
        end

        Rails.logger.info(records.to_t)

        validate!(records)

        records
      end
    end

    def table_hash_array
      header = uniquify_with_sequence(table_values_array.first)
      table_values_array.drop(1).take(take_size).collect do |values|
        header.zip(values).to_h
      end
    end

    private

    def source_url
      raise NotImplementedError, "#{__method__} is not implemented"
    end

    def attributes_from(record, index)
      raise NotImplementedError, "#{__method__} is not implemented"
    end

    def validate!(records)
      if v = params[:promotion_count_gteq]
        unless records.count { |e| e[:result_key] == "昇" } >= v
          raise "昇が#{gteq}つ以上ない"
        end
      end
    end

    # キャッシュするな
    def content_fetch
      if params[:verbose]
        tp({
            "担当"  => self.class.name,
            "期"    => season_key_vo,
            "URL"   => source_url,
            "sleep" => params[:sleep],
          })
      end

      if params[:mock]
        body = mock_file.read
      else
        sleep(params[:sleep])
        body = URI(source_url).read
      end

      utf8_and_zenkaku_to_hankaku(body)
    end

    def ox_normalize(str)
      str.scan(/[○□●■]+/).join.tr("○□●■", "ooxx")
    end

    def utf8_and_zenkaku_to_hankaku(str)
      NKF.nkf("-w -Z1", str)
    end

    def mock_file
      Pathname("#{__dir__}/mock/#{self.class.name.demodulize.underscore}.html")
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
      @doc ||= Nokogiri::HTML(content_fetch)
    end

    def default_params
      {
        :take_size => nil,
        :verbose   => Rails.env.development? || Rails.env.staging? || Rails.env.production?,
        :sleep     => (Rails.env.development? || Rails.env.staging? || Rails.env.production?) ? 0.5 : 0,
        :mock      => Rails.env.test?,
        :slice     => true,

        # validation
        :promotion_count_gteq => 0,
      }
    end

    # 重複があれば連番にして重複がないようにする
    # uniquify_with_sequence(["a", "b", "a", "b", "a"]) → ["a", "b", "a2", "b2", "a3"]
    def uniquify_with_sequence(av)
      counts = Hash.new(0)
      av.collect do |str|
        counts[str] += 1
        if counts[str] >= 2
          str = [str, counts[str]].join
        end
        str
      end
    end
  end
end
