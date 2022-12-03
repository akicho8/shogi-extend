module Swars
  class BattleUrl
    attr_reader :url
    private :url

    def initialize(url)
      BattleUrlValidator.new(url).validate!
      @url = url
    end

    def battle_key
      BattleKey.create(URI(url).path.split("/").last)
    end

    def user_key
      battle_key.user_keys.first
    end

    def to_s
      url
    end
  end
end
