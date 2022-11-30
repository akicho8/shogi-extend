module Swars
  class BattleUrl
    class << self
      def valid?(text)
        new(text).valid?
      end

      def invalid?(text)
        new(text).invalid?
      end

      def url(text)
        new(text).url
      end

      def key(text)
        new(text).key
      end

      def user_key(text)
        new(text).user_key
      end
    end

    def initialize(text)
      @text = text
    end

    def url
      @url ||= URI.extract(text, ["https"]).find { |e| e.include?("heroz.jp/games/") }
    end

    def key
      if url
        BattleKey.wrap(URI(url).path.split("/").last)
      end
    end

    def user_key
      if key
        key.user_keys.first
      end
    end

    def valid?
      !!url
    end

    def invalid?
      !valid?
    end

    private

    attr_reader :text
  end
end
