module Swars
  class KeyVo
    class << self
      def [](value)
        wrap(value)
      end

      def wrap(value)
        if value.kind_of? self
          return value
        end
        new(value).tap(&:validate!)
      end

      def valid?(value)
        new(value).valid?
      end

      def invalid?(value)
        new(value).invalid?
      end

      def generate(**params)
        KeyGenerator.generate(**params)
      end
    end

    attr_reader :key

    def initialize(key)
      @key = key.dup.freeze
    end

    def to_s
      key
    end

    def originator_url
      q = { locale: "ja" }
      "https://shogiwars.heroz.jp/games/#{self}?#{q.to_query}"
    end

    def to_time
      Time.zone.parse(parts.last)
    end

    def user_keys
      parts.take(2)
    end

    def user_key_at(location)
      location = Bioshogi::Location.fetch(location)
      parts[location.code]
    end

    def valid?
      !!(parts && parts.size == 3 && to_time)
    end

    def invalid?
      !valid?
    end

    def validate!
      if invalid?
        raise ArgumentError, @key.inspect
      end
    end

    def <=>(other)
      [self.class, key] <=> [other.class, other.key]
    end

    def ==(other)
      self.class == other.class && key == other.key
    end

    def eql?(other)
      self == other
    end

    def hash
      key.hash
    end

    def inspect
      "<#{self}>"
    end

    private

    def parts
      if @key.include?("-")
        @parts ||= @key.split("-")
      end
    end
  end
end
