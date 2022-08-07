module Swars
  class BattleIdentify
    attr_accessor :key

    def self.[](key)
      new(key)
    end

    def initialize(key)
      raise ArgumentError, "key is blank : #{key.inspect}" if key.blank?
      @key = key
      freeze
    end

    def heroz_show_url
      "https://shogiwars.heroz.jp/games/#{key}?locale=ja"
    end
  end
end
