module Swars
  class UserKey
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
      @key = key.dup.freeze
      freeze
    end

    def to_s
      key
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

    ################################################################################

    def mypage_url
      "https://shogiwars.heroz.jp/users/mypage/#{key}"
    end
  end
end
