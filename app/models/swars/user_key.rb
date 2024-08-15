module Swars
  class UserKey
    DELEGATE_METHODS = [
      :official_mypage_url,
      :official_follow_url,
      :official_follower_url,
      :swars_search_url,
      :player_info_url,
      :google_search_url,
      :twitter_search_url,
    ]

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

    ################################################################################

    def db_record
      User.find_by(key: key)
    end

    def db_record!
      User.find_by!(key: key)
    end

    ################################################################################

    def official_mypage_url
      "https://shogiwars.heroz.jp/users/mypage/#{key}"
    end

    def official_follow_url
      "https://shogiwars.heroz.jp/friends?type=follow&user_id=#{key}"
    end

    def official_follower_url
      "https://shogiwars.heroz.jp/friends?type=follower&user_id=#{key}"
    end

    def swars_search_url
      UrlProxy.full_url_for("/swars/search?query=#{key}")
    end

    def player_info_url
      UrlProxy.full_url_for("/swars/users/#{key}")
    end

    def google_search_url
      query = { q: [key, "将棋"] * " " }
      "https://www.google.co.jp/search?#{query.to_query}"
    end

    def twitter_search_url
      query = { q: [key, "将棋"] * " " }
      "https://twitter.com/search?#{query.to_query}"
    end

    ################################################################################

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
  end
end
