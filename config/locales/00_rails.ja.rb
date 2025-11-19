{
  ja: {
    # for ActiveSupport
    support: {
      array: {
        words_connector: ", ",       # 配列要素を連結するための区切り文字
        two_words_connector: " と ", # 配列の最後の2つの要素を連結するための区切り文字
        last_word_connector: "、",   # 配列の最後の要素を連結するための区切り文字
      },
    },
    errors: {
      template: {
        header: {
          # one: "%{model}に1つのエラーがあります",
          # other: "%{model}に%{count}つのエラーがあります",
          one: "1つのエラーがあります",              # %{model} が使える
          other: "%{count}つのエラーがあります",       # %{model} が使える
        },
        body: "次の項目を確認してください"
      },
      format: "%{attribute}%{message}",
      messages: {
        inclusion: "は一覧にありません",
        exclusion: "は予約されています",
        invalid: "が正しくありません",
        confirmation: "が一致しません",
        accepted: "を受諾してください",
        empty: "を入力しよう",
        blank: "を入力しよう",
        too_long: "は%{count}文字以内で入力しよう",
        too_short: "は%{count}文字以上で入力しよう",
        wrong_length: "は%{count}文字で入力しよう",
        not_a_number: "は数値で入力しよう",
        not_an_integer: "は整数で入力しよう",
        greater_than: "は%{count}より大きい値にしてください",
        greater_than_or_equal_to: "は%{count}以上の値にしてください",
        equal_to: "は%{count}にしてください",
        less_than: "は%{count}より小さい値にしてください",
        less_than_or_equal_to: "は%{count}以下の値にしてください",
        odd: "は奇数にしてください",
        even: "は偶数にしてください",
        taken: "の値 %{value} が重複しています",
      },
    },
    activerecord: {
      errors: {
        # record_invalid: "バリデーションに失敗しました %{errors}",
        messages: {
          record_invalid: "%{errors}",
        },
      },
    },
    # activemodel: {errors: errors},
    number: {
      # Used in number_with_delimiter()
      # These are also the defaults for 'currency', 'percentage', 'precision', and 'human'
      format: {
        # Sets the separator between the units, for more precision (e.g. 1.0 / 2.0 == 0.5)
        separator: ".",
        # Delimets thousands (e.g. 1,000,000 is a million) (always in groups of three)
        delimiter: ",",
        # Number of decimals, behind the separator (the number 1 with a precision of 2 gives: 1.00)
        precision: 3,
        # If set to true, precision will mean the number of significant digits instead
        # of the number of decimal digits (1234 with precision 2 becomes 1200, 1.23543 becomes 1.2)
        significant: false,
        # If set, the zeros after the decimal separator will always be stripped (eg.: 1.200 will be 1.2)
        strip_insignificant_zeros: false,
      },

      # Used in number_to_currency()
      currency: {
        format: {
          # Where is the currency sign? %u is the currency unit, %n the number (default: $5.00)
          format: "%u%n",
          unit: "$",
          # These five are to override number.format and are optional
          separator: ".",
          delimiter: ",",
          precision: 2,
          significant: false,
          strip_insignificant_zeros: false,
        },
      },

      # Used in number_to_percentage()
      percentage: {
        format: {
          # These five are to override number.format and are optional
          # separator:
          delimiter: "",
          # precision:
          # significant: false
          # strip_insignificant_zeros: false
        },
      },

      # Used in number_to_precision()
      precision: {
        format: {
          # These five are to override number.format and are optional
          # separator:
          delimiter: "",
          # precision:
          # significant: false
          # strip_insignificant_zeros: false
        },
      },

      # Used in number_to_human_size() and number_to_human()
      human: {
        format: {
          # These five are to override number.format and are optional
          # separator:
          delimiter: "",
          precision: 3,
          significant: true,
          strip_insignificant_zeros: true,
          # Used in number_to_human_size()
        },
        storage_units: {
          # Storage units output formatting.
          # %u is the storage unit, %n is the number (default: 2 MB)
          format: "%n %u",
          units: {
            byte: {
              one: "Byte",
              other: "Bytes",
            },
            kb: "KB",
            mb: "MB",
            gb: "GB",
            tb: "TB",
          },
        },
        # Used in number_to_human()
        decimal_units: {
          format: "%n %u",
          # Decimal units output formatting
          # By default we will only quantify some of the exponents
          # but the commented ones might be defined or overridden
          # by the user.
          units: {
            # femto: Quadrillionth
            # pico: Trillionth
            # nano: Billionth
            # micro: Millionth
            # mili: Thousandth
            # centi: Hundredth
            # deci: Tenth
            unit: "",
            # ten:
            #   one: Ten
            #   other: Tens
            # hundred: Hundred
            thousand: "Thousand",
            million: "Million",
            billion: "Billion",
            trillion: "Trillion",
            quadrillion: "Quadrillion",
          },
        },
      },
    },

    # Used in distance_of_time_in_words(), distance_of_time_in_words_to_now(), time_ago_in_words()
    datetime: {
      distance_in_words: {
        half_a_minute: "30秒前後",
        less_than_x_seconds: {
          one: "1秒以内",
          other: "%{count}秒以内",
        },
        x_seconds: {
          one: "1秒",
          other: "%{count}秒",
        },
        less_than_x_minutes: {
          one: "1分",
          other: "%{count}分以内",
        },
        x_minutes: {
          one: "1分",
          other: "%{count}分",
        },
        about_x_hours: {
          one: "約1時間",
          other: "約%{count}時間",
        },
        x_days: {
          one: "1日",
          other: "%{count}日",
        },
        about_x_months: {
          one: "1ヶ月",
          other: "約%{count}ヶ月",
        },
        x_months: {
          one: "1ヶ月",
          other: "%{count}ヶ月",
        },
        about_x_years: {
          one: "約%{count}年",
          other: "約%{count}年",
        },
        over_x_years: {
          one: "%{count}年以上",
          other: "%{count}年以上",
        },
        almost_x_years: {
          one: "約%{count}年",
          other: "約%{count}年",
        },
        prompts: {
          year: "年",
          month: "月",
          day: "日",
          hour: "時",
          minute: "分",
          second: "秒",
        },
      },
    },

    helpers: {
      select: {
        prompt: "--- 選択してください ---",
      },

      # モデル毎に設定する例
      # label: {
      #   article: {
      #     name: "名前",
      #   },
      # },

      # デフォルト
      submit: {
        create: "作成", # %{model} が使える
        update: "更新", # %{model} が使える

        # モデル毎に設定する例
        # article: {
        #   create: "Create a %{model}",
        #   update: "Confirm changes to %{model}",
        # },
      },
    },

    time: {
      am: "午前",
      pm: "午後",
      formats: {
        short: "%d %b %H:%M",
        long: "%B %d, %Y %H:%M",
        default: "%a, %d %b %Y %H:%M:%S %z", # for I18n.localize(Time.current)
        basic: "%m/%d %H:%M",
        time_only: "%H:%M",
      },
    },

    date: {
      order: [:year, :month, :day],
      month_names: [nil, "1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"],
      abbr_month_names: [nil, "1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"],
      day_names: ["日曜日", "月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日"],
      abbr_day_names: ["日", "月", "火", "水", "木", "金", "土"],
      formats: {
        short: "%b %d",
        long: "%B %d, %Y",
        default: "%Y-%m-%d",
      },
    },
  },
}
