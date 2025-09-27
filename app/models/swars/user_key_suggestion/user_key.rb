module Swars
  module UserKeySuggestion
    class UserKey < SimpleDelegator
      MANY_FOUND = 10           # X件以上で多いと見なす
      LIKE_SQL   = "LOWER(user_key) LIKE ?"

      def initialize(user_key)
        super(user_key.to_s)
      end

      # 大小文字を無視して完全一致する人を返す
      def same_length_user
        @same_length_user ||= Swars::User.find_by([LIKE_SQL, like_value])
      end

      # 部分一致で最も検索されている人を返す
      def suggestion_user
        @suggestion_user ||= current_scope.order(search_logs_count: :desc).take
      end

      # 部分一致した回数がわかる人間向け表記を返す
      def suggestion_count_human
        "#{suggestion_count}人#{suggestion_count_suffix}"
      end

      private

      # 部分一致スコープ
      def current_scope
        @current_scope ||= Swars::User.where([LIKE_SQL, "%#{like_value}%"])
      end

      # "ALICE_BOB" なら "alice\_bob" (MySQL依存)
      def like_value
        ActiveRecord::Base.sanitize_sql_like(downcase)
      end

      # 部分一致した回数
      def suggestion_count
        @suggestion_count ||= current_scope.count
      end

      # X件「も」
      def suggestion_count_suffix
        if suggestion_count >= MANY_FOUND
          "も"
        end
      end
    end
  end
end
