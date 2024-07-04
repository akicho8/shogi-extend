module Swars
  module Agent
    class Mypage < Base
      delegate :ban?, to: :mypage_grade

      def mypage_grade
        @mypage_grade ||= yield_self do
          text = doc.search("#user_dankyu tr").text
          MypageGrade.new(text.scan(regexp))
        end
      end

      # ここで採取したものはアルファベットの大小文字が正しい
      def real_user_key
        @real_user_key ||= yield_self do
          if s = doc.title
            s.slice(/\w+/)
          end
        end
      end

      def user_missing?
        html.blank?
      end

      def user_exist?
        html.present?
      end

      private

      def doc
        @doc ||= Nokogiri::HTML(html)
      end

      def html
        @html ||= fetcher.fetch(:mypage, mypage_url) || ""
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
