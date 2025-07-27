module Swars
  module UserKeySuggestion
    SWARS_ID_LENGTH_RANGE = 3..15 # 固定

    Commands = [
      Command.new { |user_key|
        if e = Bioshogi::Analysis::TagIndex.fuzzy_lookup(user_key)
          "#{e.name}に該当する#{e.human_name}は見つかりません"
        end
      },
      Command.new { |user_key|
        if e = PresetInfo.lookup(user_key)
          "#{e.name}に該当する手合割は見つかりません"
        end
      },
      Command.new { |user_key|
        if user_key.match?(/[\p{Hiragana}\p{Katakana}\p{Han}]/) && user_key.length >= 50
          "めちゃくちゃな入力をしないでください"
        end
      },
      Command.new { |user_key|
        if user_key.match?(%r{\A[a-z\d][a-z\d\.\-_]+@[a-z\d\.\-]+[a-z]\z}i)
          "それはウォーズIDではなくメールアドレスです"
        end
      },
      Command.new { |user_key|
        if user_key.match?(/[\p{Hiragana}\p{Katakana}\p{Han}]/) # あ ア 漢
          "ウォーズIDはアルファベットや数字です"
        end
      },
      Command.new { |user_key|
        if user_key.match?(/[[:^ascii:]&&[:alnum:]]/) # 全角 かつ ０−９Ａ−Ｚ
          "ウォーズIDは半角で入力してください"
        end
      },
      Command.new { |user_key|
        if av = user_key.scan(/[[:^ascii:]&&[:^alnum:]]/).presence # 全角 かつ ０−９Ａ−Ｚ 以外なので全角記号
          s = av.uniq.join
          "#{s} の部分も半角で入力してください"
        end
      },
      Command.new { |user_key|
        if user_key.match?(/[[:alnum:]]/) && user_key.length < SWARS_ID_LENGTH_RANGE.min
          "ウォーズIDは#{SWARS_ID_LENGTH_RANGE.min}文字以上です"
        end
      },
      Command.new { |user_key|
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
      Command.new { |user_key|
        "真面目に入力してください"
      },
    ]
  end
end
