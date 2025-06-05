module Swars
  class GradeInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "十段",    visualize: false, select_option: true,  show_in_search_script: true,  teacher: true,  hourly_active_user: false, lose_pattern: true,  range_10kyu_to_9dan: false, range_30kyu_to_9dan: false, },
      { key: "九段",    visualize: true,  select_option: true,  show_in_search_script: true,  teacher: false, hourly_active_user: false, lose_pattern: true,  range_10kyu_to_9dan: true,  range_30kyu_to_9dan: true,  },
      { key: "八段",    visualize: true,  select_option: true,  show_in_search_script: true,  teacher: false, hourly_active_user: true,  lose_pattern: true,  range_10kyu_to_9dan: true,  range_30kyu_to_9dan: true,  },
      { key: "七段",    visualize: true,  select_option: true,  show_in_search_script: true,  teacher: false, hourly_active_user: true,  lose_pattern: true,  range_10kyu_to_9dan: true,  range_30kyu_to_9dan: true,  },
      { key: "六段",    visualize: true,  select_option: true,  show_in_search_script: true,  teacher: false, hourly_active_user: true,  lose_pattern: true,  range_10kyu_to_9dan: true,  range_30kyu_to_9dan: true,  },
      { key: "五段",    visualize: true,  select_option: true,  show_in_search_script: true,  teacher: false, hourly_active_user: true,  lose_pattern: true,  range_10kyu_to_9dan: true,  range_30kyu_to_9dan: true,  },
      { key: "四段",    visualize: true,  select_option: true,  show_in_search_script: true,  teacher: false, hourly_active_user: true,  lose_pattern: true,  range_10kyu_to_9dan: true,  range_30kyu_to_9dan: true,  },
      { key: "三段",    visualize: true,  select_option: true,  show_in_search_script: true,  teacher: false, hourly_active_user: true,  lose_pattern: true,  range_10kyu_to_9dan: true,  range_30kyu_to_9dan: true,  },
      { key: "二段",    visualize: true,  select_option: true,  show_in_search_script: true,  teacher: false, hourly_active_user: true,  lose_pattern: true,  range_10kyu_to_9dan: true,  range_30kyu_to_9dan: true,  },
      { key: "初段",    visualize: true,  select_option: true,  show_in_search_script: true,  teacher: false, hourly_active_user: true,  lose_pattern: true,  range_10kyu_to_9dan: true,  range_30kyu_to_9dan: true,  },
      { key:  "1級",    visualize: true,  select_option: true,  show_in_search_script: true,  teacher: false, hourly_active_user: true,  lose_pattern: true,  range_10kyu_to_9dan: true,  range_30kyu_to_9dan: true,  },
      { key:  "2級",    visualize: true,  select_option: true,  show_in_search_script: true,  teacher: false, hourly_active_user: true,  lose_pattern: true,  range_10kyu_to_9dan: true,  range_30kyu_to_9dan: true,  },
      { key:  "3級",    visualize: true,  select_option: true,  show_in_search_script: true,  teacher: false, hourly_active_user: true,  lose_pattern: true,  range_10kyu_to_9dan: true,  range_30kyu_to_9dan: true,  },
      { key:  "4級",    visualize: true,  select_option: false, show_in_search_script: true,  teacher: false, hourly_active_user: true,  lose_pattern: true,  range_10kyu_to_9dan: true,  range_30kyu_to_9dan: true,  },
      { key:  "5級",    visualize: true,  select_option: false, show_in_search_script: true,  teacher: false, hourly_active_user: true,  lose_pattern: true,  range_10kyu_to_9dan: true,  range_30kyu_to_9dan: true,  },
      { key:  "6級",    visualize: true,  select_option: false, show_in_search_script: true,  teacher: false, hourly_active_user: true,  lose_pattern: true,  range_10kyu_to_9dan: true,  range_30kyu_to_9dan: true,  },
      { key:  "7級",    visualize: true,  select_option: false, show_in_search_script: true,  teacher: false, hourly_active_user: false, lose_pattern: true,  range_10kyu_to_9dan: true,  range_30kyu_to_9dan: true,  },
      { key:  "8級",    visualize: true,  select_option: false, show_in_search_script: true,  teacher: false, hourly_active_user: false, lose_pattern: true,  range_10kyu_to_9dan: true,  range_30kyu_to_9dan: true,  },
      { key:  "9級",    visualize: true,  select_option: false, show_in_search_script: true,  teacher: false, hourly_active_user: false, lose_pattern: true,  range_10kyu_to_9dan: true,  range_30kyu_to_9dan: true,  },
      { key: "10級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, lose_pattern: true,  range_10kyu_to_9dan: true,  range_30kyu_to_9dan: true,  },
      { key: "11級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, lose_pattern: true,  range_10kyu_to_9dan: false, range_30kyu_to_9dan: false, },
      { key: "12級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, lose_pattern: true,  range_10kyu_to_9dan: false, range_30kyu_to_9dan: false, },
      { key: "13級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, lose_pattern: true,  range_10kyu_to_9dan: false, range_30kyu_to_9dan: false, },
      { key: "14級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, lose_pattern: true,  range_10kyu_to_9dan: false, range_30kyu_to_9dan: false, },
      { key: "15級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, lose_pattern: true,  range_10kyu_to_9dan: false, range_30kyu_to_9dan: false, },
      { key: "16級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, lose_pattern: true,  range_10kyu_to_9dan: false, range_30kyu_to_9dan: false, },
      { key: "17級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, lose_pattern: true,  range_10kyu_to_9dan: false, range_30kyu_to_9dan: false, },
      { key: "18級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, lose_pattern: true,  range_10kyu_to_9dan: false, range_30kyu_to_9dan: false, },
      { key: "19級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, lose_pattern: true,  range_10kyu_to_9dan: false, range_30kyu_to_9dan: false, },
      { key: "20級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, lose_pattern: true,  range_10kyu_to_9dan: false, range_30kyu_to_9dan: false, },
      { key: "21級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, lose_pattern: true,  range_10kyu_to_9dan: false, range_30kyu_to_9dan: false, },
      { key: "22級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, lose_pattern: true,  range_10kyu_to_9dan: false, range_30kyu_to_9dan: false, },
      { key: "23級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, lose_pattern: true,  range_10kyu_to_9dan: false, range_30kyu_to_9dan: false, },
      { key: "24級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, lose_pattern: true,  range_10kyu_to_9dan: false, range_30kyu_to_9dan: false, },
      { key: "25級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, lose_pattern: true,  range_10kyu_to_9dan: false, range_30kyu_to_9dan: false, },
      { key: "26級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, lose_pattern: true,  range_10kyu_to_9dan: false, range_30kyu_to_9dan: false, },
      { key: "27級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, lose_pattern: true,  range_10kyu_to_9dan: false, range_30kyu_to_9dan: false, },
      { key: "28級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, lose_pattern: true,  range_10kyu_to_9dan: false, range_30kyu_to_9dan: false, },
      { key: "29級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, lose_pattern: true,  range_10kyu_to_9dan: false, range_30kyu_to_9dan: false, },
      { key: "30級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, lose_pattern: true,  range_10kyu_to_9dan: false, range_30kyu_to_9dan: false, },
      { key: "10000級", visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, lose_pattern: false, range_10kyu_to_9dan: false, range_30kyu_to_9dan: false, }, # ただのフラグ的な扱いなので10000級を表に表示してはいけない
    ]

    prepend AliasMod

    BEGINNER = 30               # 違反していない範囲での最低級位
    BAN_KEY  = :"10000級"        # 垢BANしたとみなす表示上の級位表記

    class << self
      def ban
        @ban ||= fetch(BAN_KEY)
      end

      def key_cast(v)
        if v.kind_of? String
          v = v.tr("０-９", "0-9")
          v = v.gsub(/\b[一1]段/, "初段")
          v = v.gsub(/(\d+)(?=段)/) { |s| Bioshogi::KanjiNumber.number_to_kanji(s.to_i) }
          v = v.gsub(/([十〇一二三四五六八九]+)(?=級)/) { |s| Bioshogi::KanjiNumber.kanji_to_number_string(s) }
          if v.match?(/\A\d+級\z/) # これを入れないとウォーズID「123_456」などが変換されてしまう
            if v.to_i > BEGINNER
              v = BAN_KEY
            end
          end
        end
        v
      end

      def active_only
        @active_only ||= values - [ban]
      end
    end

    def ban?
      key == BAN_KEY
    end

    def priority
      code
    end

    def score
      @score ||= self.class.values.last.code - code
    end

    def short_name
      @short_name ||= name.remove(/[段級]/)
    end

    def el_label
      short_name
    end
  end
end
