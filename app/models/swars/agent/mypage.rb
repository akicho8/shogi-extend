module Swars
  module Agent
    class Mypage < Base
      def fetch
        @fetch ||= yield_self do
          text = doc.search("#user_dankyu tr").text
          list = text.scan(regexp).collect do |rule, grade|
            {
              rule: Swars::RuleInfo.fetch(rule),
              grade: Swars::GradeInfo.fetch(grade),
            }
          end
          MypageResult.new(list)
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
    end
  end
end
