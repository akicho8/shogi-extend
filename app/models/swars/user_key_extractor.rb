module Swars
  class UserKeyExtractor
    attr_accessor :query_info

    def initialize(query_info)
      @query_info = query_info
    end

    def extract
      case_history_or_user_url || case_battle_url || case_values
    end

    private

    # https://shogiwars.heroz.jp/users/history/foo?gtype=&locale=ja -> foo
    # https://shogiwars.heroz.jp/users/foo                          -> foo
    def case_history_or_user_url
      if url = query_info.urls.first
        if url = URI::Parser.new.extract(url).first
          uri = URI(url)
          if uri.path
            if md = uri.path.match(%r{/users/history/(.*)|/users/(.*)})
              s = md.captures.compact.first
              ERB::Util.html_escape(s)
            end
          end
        end
      end
    end

    # https://shogiwars.heroz.jp/games/foo-bar-20200204_211329" --> foo
    def case_battle_url
      if url = query_info.urls.first
        Swars::Battle.user_key_extract_from_battle_url(url)
      end
    end

    # "foo" --> foo
    def case_values
      query_info.values.first
    end
  end
end
