module Swars
  module Agent
    class MyPage < Base
      delegate :ban?, to: :rule_grade_list

      def rule_grade_list
        @rule_grade_list ||= RuleGradeList.parse(doc.search("#user_dankyu tr").text)
      end

      # ここで採取したものはアルファベットの大小文字が正しい
      def real_user_key
        @real_user_key ||= yield_self do
          if s = doc.title
            s.slice(/\w+/)
          end
        end
      end

      def page_not_found?
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
        @html ||= fetcher.fetch(:my_page, official_mypage_url) || ""
      end

      def official_mypage_url
        UserKey.new(params.fetch(:user_key)).official_mypage_url
      end
    end
  end
end
