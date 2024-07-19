module Swars
  class BattleKey
    class << self
      def [](key)
        create(key)
      end

      def create(key)
        if key.kind_of? self
          return key
        end
        new(key)
      end
    end

    attr_reader :key

    def initialize(key)
      BattleKeyValidator.new(key).validate!
      @key = key.dup.freeze
      @cache = {}
      freeze
    end

    def to_s
      key
    end

    def official_url
      q = { locale: "ja" }
      "https://shogiwars.heroz.jp/games/#{self}?#{q.to_query}"
    end

    def my_url
      UrlProxy.full_url_for("/swars/battles/#{self}")
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
      @cache[:parts] ||= key.split("-")
    end
  end
end
