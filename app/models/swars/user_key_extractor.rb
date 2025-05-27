# 1. クエリの値に含まれる公式のマイページURLから抽出する
# 2. クエリの値に含まれる対局URLから抽出する
# 3. クエリの値

module Swars
  class UserKeyExtractor
    attr_accessor :query_info

    def initialize(query_info)
      @query_info = query_info
    end

    def call
      extract
    end

    def extract
      case_official_home_url || case_official_battle_url || case_any_values_first
    end

    private

    # https://shogiwars.heroz.jp/users/history/foo?gtype=&locale=ja -> foo
    # https://shogiwars.heroz.jp/users/foo                          -> foo
    def case_official_home_url
      if url = query_info.urls.first
        if url = URI::Parser.new.extract(url).first
          uri = URI(url)
          if uri.path
            if md = uri.path.match(%r{/users/history/(.*)|/users/(.*)})
              UserKey[md.captures.compact.first]
            end
          end
        end
      end
    end

    # https://shogiwars.heroz.jp/games/foo-bar-20200204_211329" --> foo
    def case_official_battle_url
      if url = query_info.urls.first
        if battle_url = BattleUrlExtractor.new(url).battle_url
          UserKey[battle_url.user_key]
        end
      end
    end

    # "foo" --> foo
    # この場合は、本当にウォーズIDかどうか怪しい。入力が間違っている恐れもある。
    def case_any_values_first
      if value = query_info.values.first
        if UserKeyValidator.valid?(value)
          UserKey[value]
        end
      end
    end
  end
end
