module Swars
  module Agent
    class HistoryBox
      KEYS_PER_PAGE = 10        # 1ページあたりX件

      attr_accessor :all_keys

      class << self
        def empty
          new
        end
      end

      def initialize(all_keys = [])
        @all_keys = all_keys
      end

      # 最後のページか？
      # もし1ページ目に9件しかなければ2ページ目を見る必要がない
      def last_page?
        all_keys.size < KEYS_PER_PAGE
      end

      # 既存のレコードを除いた新しいキーたち
      def new_keys
        @new_keys ||= yield_self do
          av = all_keys.collect(&:to_s)
          av = av - Battle.where(key: av).pluck(:key)
          av.collect { |e| BattleKey.create(e) }
        end
      end

      def inspect
        "[全#{all_keys.size}件][新#{new_keys.size}件][#{last_page? ? '最後' : '続く'}]"
      end
    end
  end
end
