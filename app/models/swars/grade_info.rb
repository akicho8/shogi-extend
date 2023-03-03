module Swars
  class GradeInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "十段", visualize: false, select_option: true,  },
      { key: "九段", visualize: true,  select_option: true,  },
      { key: "八段", visualize: true,  select_option: true,  },
      { key: "七段", visualize: true,  select_option: true,  },
      { key: "六段", visualize: true,  select_option: true,  },
      { key: "五段", visualize: true,  select_option: true,  },
      { key: "四段", visualize: true,  select_option: true,  },
      { key: "三段", visualize: true,  select_option: true,  },
      { key: "二段", visualize: true,  select_option: true,  },
      { key: "初段", visualize: true,  select_option: true,  },
      { key:  "1級", visualize: true,  select_option: true,  },
      { key:  "2級", visualize: true,  select_option: true,  },
      { key:  "3級", visualize: true,  select_option: true,  },
      { key:  "4級", visualize: true,  select_option: false, },
      { key:  "5級", visualize: true,  select_option: false, },
      { key:  "6級", visualize: true,  select_option: false, },
      { key:  "7級", visualize: true,  select_option: false, },
      { key:  "8級", visualize: true,  select_option: false, },
      { key:  "9級", visualize: true,  select_option: false, },
      { key: "10級", visualize: false, select_option: false, },
      { key: "11級", visualize: false, select_option: false, },
      { key: "12級", visualize: false, select_option: false, },
      { key: "13級", visualize: false, select_option: false, },
      { key: "14級", visualize: false, select_option: false, },
      { key: "15級", visualize: false, select_option: false, },
      { key: "16級", visualize: false, select_option: false, },
      { key: "17級", visualize: false, select_option: false, },
      { key: "18級", visualize: false, select_option: false, },
      { key: "19級", visualize: false, select_option: false, },
      { key: "20級", visualize: false, select_option: false, },
      { key: "21級", visualize: false, select_option: false, },
      { key: "22級", visualize: false, select_option: false, },
      { key: "23級", visualize: false, select_option: false, },
      { key: "24級", visualize: false, select_option: false, },
      { key: "25級", visualize: false, select_option: false, },
      { key: "26級", visualize: false, select_option: false, },
      { key: "27級", visualize: false, select_option: false, },
      { key: "28級", visualize: false, select_option: false, },
      { key: "29級", visualize: false, select_option: false, },
      { key: "30級", visualize: false, select_option: false, },
      { key: "10000級", visualize: false, select_option: false, },
    ]

    class << self
      def lookup(v)
        if v.kind_of? String
          v = v.tr("０-９", "0-9")
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

    def priority
      code
    end

    def short_name
      @short_name ||= name.remove(/[段級]/)
    end

    def kanji_number_dan
      if name.include?("段")
        Bioshogi::KanjiNumber.kanji_to_number_string(name)
      end
    end
  end
end
