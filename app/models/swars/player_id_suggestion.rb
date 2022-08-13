module Swars
  class PlayerIdSuggestion
    SWARS_ID_LENGTH_RANGE = 3..15 # 固定

    attr_accessor :user_key

    def initialize(user_key)
      @user_key = user_key
    end

    def message
      s = nil
      s ||= case_zenkaku_ni_nattoru
      s ||= case_too_min
      s ||= case_suggestion
      s ||= case_default
    end

    private

    def case_zenkaku_ni_nattoru
      if user_key.match?(/[[:^ascii:]&&[:graph:]]/)
        "ウォーズIDは半角で入力してください"
      end
    end

    def case_too_min
      if user_key.match?(/[[:alpha:]]/) && user_key.length < SWARS_ID_LENGTH_RANGE.min
        "ウォーズIDは#{SWARS_ID_LENGTH_RANGE.min}文字以上です"
      end
    end

    def case_suggestion
      if user_key.match?(/[[:alpha:]]/) && SWARS_ID_LENGTH_RANGE.cover?(user_key.length)
        case
        when same_length_user
          "もしかして #{same_length_user.key} ですか？ 大文字と小文字を区別して入力してください"
        when suggestion
          "#{user_key} に該当する人は#{suggestion_count}人います。もしかして #{suggestion.key} ですか？"
        else
          "#{user_key} に該当する人はいません。正確に入力してください"
        end
      end
    end

    def case_default
      "真面目に入力してください"
    end

    # 大文字小文字を無視すると完全一致するユーザー
    def same_length_user
      @same_length_user ||= Swars::User.find_by(["LOWER(user_key) LIKE ?", like_value])
    end

    # 部分一致でもっとも検索されている人を返す
    def suggestion
      @suggestion ||= current_scope.order(search_logs_count: :desc).take
    end

    # 部分一致した回数
    def suggestion_count
      @suggestion_count ||= current_scope.count
    end

    # 部分一致スコープ
    def current_scope
      @current_scope ||= Swars::User.where(["LOWER(user_key) LIKE ?", "%#{like_value}%"])
    end

    def like_value
      mysql_underscore_escape(user_key.downcase)
    end

    def mysql_underscore_escape(str)
      str.gsub(/_/, "\\_")
    end
  end
end
