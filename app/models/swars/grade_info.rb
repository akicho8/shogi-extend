module Swars
  class GradeInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "十段", visualize: false, },
      { key: "九段", visualize: true,  },
      { key: "八段", visualize: true,  },
      { key: "七段", visualize: true,  },
      { key: "六段", visualize: true,  },
      { key: "五段", visualize: true,  },
      { key: "四段", visualize: true,  },
      { key: "三段", visualize: true,  },
      { key: "二段", visualize: true,  },
      { key: "初段", visualize: true,  },
      { key:  "1級", visualize: true,  },
      { key:  "2級", visualize: true,  },
      { key:  "3級", visualize: true,  },
      { key:  "4級", visualize: true,  },
      { key:  "5級", visualize: true,  },
      { key:  "6級", visualize: true,  },
      { key:  "7級", visualize: true,  },
      { key:  "8級", visualize: true,  },
      { key:  "9級", visualize: true,  },
      { key: "10級", visualize: false, },
      { key: "11級", visualize: false, },
      { key: "12級", visualize: false, },
      { key: "13級", visualize: false, },
      { key: "14級", visualize: false, },
      { key: "15級", visualize: false, },
      { key: "16級", visualize: false, },
      { key: "17級", visualize: false, },
      { key: "18級", visualize: false, },
      { key: "19級", visualize: false, },
      { key: "20級", visualize: false, },
      { key: "21級", visualize: false, },
      { key: "22級", visualize: false, },
      { key: "23級", visualize: false, },
      { key: "24級", visualize: false, },
      { key: "25級", visualize: false, },
      { key: "26級", visualize: false, },
      { key: "27級", visualize: false, },
      { key: "28級", visualize: false, },
      { key: "29級", visualize: false, },
      { key: "30級", visualize: false, },
    ]

    def priority
      code
    end

    def reverse_priority
      self.class.count.pred - code
    end
  end
end
