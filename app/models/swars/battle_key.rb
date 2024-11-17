# battle_key = Swars::BattleKey["alice-bob-20130531_010024"]
# battle_key.to_s                 # => "alice-bob-20130531_010024"
# battle_key.official_url         # => "https://shogiwars.heroz.jp/games/alice-bob-20130531_010024"
# battle_key.inside_show_url      # => "http://localhost:4000/swars/battles/alice-bob-20130531_010024"
# battle_key.kento_url            # => "http://localhost:4000/swars/battles/alice-bob-20130531_010024/kento"
# battle_key.piyo_shogi_url       # => "http://localhost:4000/swars/battles/alice-bob-20130531_010024/piyo_shogi"
# battle_key.search_url           # => "http://localhost:4000/swars/search?query=https://shogiwars.heroz.jp/games/alice-bob-20130531_010024"
# battle_key.to_time              # => Fri, 31 May 2013 01:00:24.000000000 JST +09:00
# battle_key.user_keys            # => [<alice>, <bob>]
# battle_key.user_key_at(:white)  # => <bob>

module Swars
  class BattleKey
    DELEGATE_METHODS = [
      :official_url,
      :inside_show_url,
      :kento_url,
      :piyo_shogi_url,
      :search_url,
      :to_time,
      :user_keys,
      :user_key_at,
    ]

    class << self
      def [](...)
        create(...)
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
      BattleKeyValidator.new(key).validate! # 生焼けオブジェクトは作らせない

      @key = key.dup.freeze
      @cache = {}
      freeze
    end

    def to_s
      key
    end

    # 本家
    def official_url
      "https://shogiwars.heroz.jp/games/#{self}"
    end

    # 棋譜検索の詳細
    def inside_show_url
      UrlProxy.full_url_for("/swars/battles/#{self}")
    end

    # KENTOへのショートカット
    def kento_url
      UrlProxy.full_url_for("/swars/battles/#{self}/kento")
    end

    # ぴよ将棋へのショートカット
    def piyo_shogi_url
      UrlProxy.full_url_for("/swars/battles/#{self}/piyo_shogi")
    end

    # 棋譜検索
    def search_url
      UrlProxy.full_url_for("/swars/search?query=#{official_url}")
    end

    # 対局日時
    def to_time
      Time.zone.parse(parts.last)
    end

    # 両対局者名
    def user_keys
      @cache[:user_keys] ||= parts.take(2).collect { |e| UserKey[e] }
    end

    # 両対局者名を :black や :white で引く
    def user_key_at(location)
      location = Bioshogi::Location.fetch(location)
      user_keys[location.code]
    end

    ################################################################################

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
