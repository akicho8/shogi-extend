module Swars
  class PlayerIdSuggestion
    FETCH_MAX             = 5     # 候補として取得する数(任意)
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
        "半角で入力してください"
      end
    end

    def case_suggestion
      if user_key.match?(/[[:alpha:]]/) && SWARS_ID_LENGTH_RANGE.cover?(user_key.length)
        case
        when same_length_user
          "もしかして #{same_length_user.key} さんですか？ 大文字と小文字を区別して入力してください"
        when suggestion.length >= FETCH_MAX
          "#{user_key} から始まる人は#{FETCH_MAX}人以上います。もっと正確に入力してください"
        when user = suggestion.sample
          "もしかして #{user.key} さんですか？"
        else
          "#{user_key} から始まる人はいません。正確に入力してください"
        end
      end
    end

    def case_too_min
      if user_key.match?(/[[:alpha:]]/) && user_key.length < SWARS_ID_LENGTH_RANGE.min
        "ウォーズIDは#{SWARS_ID_LENGTH_RANGE.min}文字以上です"
      end
    end

    def case_default
      "真面目に入力してください"
    end

    # 大文字小文字を無視すると完全一致するユーザー
    def same_length_user
      @same_length_user ||= Swars::User.where(["LOWER(user_key) LIKE ?", user_key.downcase]).first
    end

    def suggestion
      @suggestion ||= Swars::User.where(["LOWER(user_key) LIKE ?", user_key.downcase + "%"]).limit(FETCH_MAX)
    end
  end
end
