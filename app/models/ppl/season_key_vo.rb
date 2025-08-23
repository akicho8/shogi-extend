module Ppl
  SeasonKeyVo = Data.define(:key) do
    class << self
      def [](key)
        if key.kind_of? self
          return key
        end
        new(key)
      end

      def start
        self[AntiquitySpider.accept_range.min]
      end
    end

    def initialize(...)
      super

      if key.kind_of? Integer
        raise TypeError, key.inspect
      end

      unless spider_klass
        raise SpiderKlassNotFound, key.inspect
      end
    end

    def season
      Season.find_or_create_by!(key: key)
    end

    def to_i
      key[/\d+/].to_i
    end

    def to_zero_padding_s
      "%02d" % to_i
    end

    def to_s
      key
    end

    def inspect
      to_s
    end

    def succ
      if key == AntiquitySpider.accept_range.max
        v = MedievalSpider.accept_range.min
      else
        v = key.succ
      end
      self.class.new(v)
    end

    def spider_klass
      [
        AntiquitySpider,
        MedievalSpider,
        ModernitySpider,
      ].find { |e| e.accept_range.include?(key) }
    end

    def spider(options = {})
      spider_klass.new(options.merge(season_key_vo: self))
    end

    def records(options = {})
      spider.call
    end
  end
end
