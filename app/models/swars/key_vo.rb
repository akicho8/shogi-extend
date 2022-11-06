# キーは "(先手名)-(後手名)-(日付)" となっているので最後を開始日時とする

module Swars
  class KeyVo
    class << self
      def wrap(value)
        if value.kind_of? self
          return value
        end
        object = new(value)
        object.validate!
        object
      end

      def valid?(value)
        new(value).valid?
      end

      def invalid?(value)
        new(value).invalid?
      end
    end

    attr_reader :key

    def initialize(key)
      @key = key.dup.freeze
    end

    def to_s
      key
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

    private

    def parts
      if @key.include?("-")
        @parts ||= @key.split("-")
      end
    end
  end
end
