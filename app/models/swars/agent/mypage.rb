module Swars
  module Agent
    class Mypage < Base
      def fetch
        @fetch ||= yield_self do
          text = doc.search("#user_dankyu tr").text
          MypageResult.new(text.scan(regexp))
        end
      end

      def doc
        @doc ||= Nokogiri::HTML(html)
      end

      def html
        fetcher.fetch(:mypage, mypage_url)
      end

      def mypage_url
        "https://shogiwars.heroz.jp/users/mypage/#{params.fetch(:user_key)}"
      end

      def regexp
        /(#{Swars::RuleInfo.collect(&:name).join("|")})\s*(\S+[級段])/o
      end
    end
  end
end
