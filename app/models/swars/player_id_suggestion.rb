module Swars
  class PlayerIdSuggestion
    SWARS_ID_LENGTH_RANGE = 3..15 # 固定

    Functions = [
      -> user_key {
        if e = Bioshogi::TacticInfo.flat_lookup(user_key) || PresetInfo.lookup(user_key)
          "最初に特定のウォーズIDで検索してからカスタム検索で#{e.name}を選択してください"
        end
      },
      -> user_key {
        if user_key.match?(/[\p{Hiragana}\p{Katakana}\p{Han}]/) && user_key.length >= 50
          "めちゃくちゃな入力をしないでください"
        end
      },
      -> user_key {
        if user_key.match?(%r/\A[a-z\d][a-z\d\.\-_]+@[a-z\d\.\-]+[a-z]\z/i)
          "ウォーズIDはメールアドレスではありません"
        end
      },
      -> user_key {
        if user_key.match?(/[\p{Hiragana}\p{Katakana}\p{Han}]/) # あ ア 漢
          "ウォーズIDはアルファベットや数字です"
        end
      },
      -> user_key {
        if user_key.match?(/[[:^ascii:]&&[:alnum:]]/) # 全角 かつ ０−９Ａ−Ｚ
          "ウォーズIDは半角で入力してください"
        end
      },
      -> user_key {
        if user_key.match?(/[[:^ascii:]&&[:alnum:]]/) # 全角 かつ ０−９Ａ−Ｚ
          "ウォーズIDは半角で入力してください"
        end
      },
      -> user_key {
        if av = user_key.scan(/[[:^ascii:]&&[:^alnum:]]/).presence # 全角 かつ ０−９Ａ−Ｚ 以外なので全角記号
          s = av.uniq.join
          "#{s} の部分も半角で入力してください"
        end
      },
      -> user_key {
        if user_key.match?(/[[:alnum:]]/) && user_key.length < SWARS_ID_LENGTH_RANGE.min
          "ウォーズIDは#{SWARS_ID_LENGTH_RANGE.min}文字以上です"
        end
      },
      -> user_key {
        if user_key.match?(/[[:alnum:]]/) && SWARS_ID_LENGTH_RANGE.cover?(user_key.length)
          case
          when user = user_key.same_length_user
            "もしかして #{user.key} ですか？ 大文字と小文字を区別して入力してください"
          when user = user_key.suggestion_user
            "#{user_key} に似た人は#{user_key.suggestion_count_human}います。もしかして #{user.key} ですか？"
          else
            "#{user_key} に似た人はいません。正確に入力してください"
          end
        end
      },
      -> user_key {
        "真面目に入力してください"
      },
    ]

    def initialize(user_key)
      @dirty_user_key = DirtyUserKey.new(user_key)
    end

    def message
      str = nil
      Functions.each do |e|
        if str = e.call(@dirty_user_key)
          break
        end
      end
      str
    end

    class DirtyUserKey < SimpleDelegator
      LIKE_SQL = "LOWER(user_key) LIKE ?"

      # 大文字小文字を無視すると完全一致するユーザー
      def same_length_user
        @same_length_user ||= Swars::User.find_by([LIKE_SQL, like_value])
      end

      # 部分一致でもっとも検索されている人を返す
      def suggestion_user
        @suggestion_user ||= current_scope.order(search_logs_count: :desc).take
      end

      # 部分一致した回数(人間用表記)
      def suggestion_count_human
        "#{suggestion_count}人#{suggestion_count_suffix}"
      end

      private

      # 部分一致スコープ
      def current_scope
        @current_scope ||= Swars::User.where([LIKE_SQL, "%#{like_value}%"])
      end

      # "ALICE_BOB" なら "alice\_bob"
      def like_value
        mysql_underscore_escape(downcase)
      end

      def mysql_underscore_escape(str)
        str.gsub(/_/, "\\_")
      end

      # 部分一致した回数
      def suggestion_count
        @suggestion_count ||= current_scope.count
      end

      # 「も」
      def suggestion_count_suffix
        if suggestion_count >= 10
          "も"
        end
      end
    end
  end
end
