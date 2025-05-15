module Swars
  class GradeInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "十段",    visualize: false, select_option: true,  show_in_search_script: true,  teacher: true,  hourly_active_user: false, },
      { key: "九段",    visualize: true,  select_option: true,  show_in_search_script: true,  teacher: false, hourly_active_user: false, },
      { key: "八段",    visualize: true,  select_option: true,  show_in_search_script: true,  teacher: false, hourly_active_user: true,  },
      { key: "七段",    visualize: true,  select_option: true,  show_in_search_script: true,  teacher: false, hourly_active_user: true,  },
      { key: "六段",    visualize: true,  select_option: true,  show_in_search_script: true,  teacher: false, hourly_active_user: true,  },
      { key: "五段",    visualize: true,  select_option: true,  show_in_search_script: true,  teacher: false, hourly_active_user: true,  },
      { key: "四段",    visualize: true,  select_option: true,  show_in_search_script: true,  teacher: false, hourly_active_user: true,  },
      { key: "三段",    visualize: true,  select_option: true,  show_in_search_script: true,  teacher: false, hourly_active_user: true,  },
      { key: "二段",    visualize: true,  select_option: true,  show_in_search_script: true,  teacher: false, hourly_active_user: true,  },
      { key: "初段",    visualize: true,  select_option: true,  show_in_search_script: true,  teacher: false, hourly_active_user: true,  },
      { key:  "1級",    visualize: true,  select_option: true,  show_in_search_script: true,  teacher: false, hourly_active_user: true,  },
      { key:  "2級",    visualize: true,  select_option: true,  show_in_search_script: true,  teacher: false, hourly_active_user: true,  },
      { key:  "3級",    visualize: true,  select_option: true,  show_in_search_script: true,  teacher: false, hourly_active_user: true,  },
      { key:  "4級",    visualize: true,  select_option: false, show_in_search_script: true,  teacher: false, hourly_active_user: true,  },
      { key:  "5級",    visualize: true,  select_option: false, show_in_search_script: true,  teacher: false, hourly_active_user: true,  },
      { key:  "6級",    visualize: true,  select_option: false, show_in_search_script: true,  teacher: false, hourly_active_user: true,  },
      { key:  "7級",    visualize: true,  select_option: false, show_in_search_script: true,  teacher: false, hourly_active_user: false, },
      { key:  "8級",    visualize: true,  select_option: false, show_in_search_script: true,  teacher: false, hourly_active_user: false, },
      { key:  "9級",    visualize: true,  select_option: false, show_in_search_script: true,  teacher: false, hourly_active_user: false, },
      { key: "10級",    visualize: true,  select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, },
      { key: "11級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, },
      { key: "12級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, },
      { key: "13級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, },
      { key: "14級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, },
      { key: "15級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, },
      { key: "16級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, },
      { key: "17級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, },
      { key: "18級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, },
      { key: "19級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, },
      { key: "20級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, },
      { key: "21級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, },
      { key: "22級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, },
      { key: "23級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, },
      { key: "24級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, },
      { key: "25級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, },
      { key: "26級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, },
      { key: "27級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, },
      { key: "28級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, },
      { key: "29級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, },
      { key: "30級",    visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, },
      { key: "10000級", visualize: false, select_option: false, show_in_search_script: false, teacher: false, hourly_active_user: false, }, # ただのフラグ的な扱いなので10000級を表に表示してはいけない
    ]

    BEGINNER = 30               # 違反していない範囲での最低級位
    BAN_KEY  = :"10000級"        # 垢BANしたとみなす表示上の級位表記

    class << self
      def ban
        @ban ||= fetch(BAN_KEY)
      end

      def lookup(v)
        if v.kind_of? String
          v = v.tr("０-９", "0-9")
          if v.to_i > BEGINNER
            v = BAN_KEY
          end
        end
        super || invert_table[v]
      end

      private

      def invert_table
        @invert_table ||= inject({}) do |a, e|
          a = a.merge({
              e.short_name => e,
            })
          if v = e.kanji_number_dan
            a = a.merge(v => e)
          end
          a
        end
      end
    end

    def ban?
      key == BAN_KEY
    end

    def priority
      code
    end

    def short_name
      @short_name ||= name.remove(/[段級]/)
    end

    def el_label
      short_name
    end

    def kanji_number_dan
      if name.include?("段")
        Bioshogi::KanjiNumber.kanji_to_number_string(name)
      end
    end
  end
end
