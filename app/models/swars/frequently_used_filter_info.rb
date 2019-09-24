module Swars
  class FrequentlyUsedFilterInfo
    include ApplicationMemoryRecord
    memory_record [
      { name: "アヒル戦法",               params: { query: "or_tag:アヒル戦法,アヒル囲い",         }, },
      { name: "相入玉",                   params: { query: "tag:相入玉",                           }, },
      { name: "相居玉",                   params: { query: "tag:相居玉",                           }, },
      { name: "200手以上",                params: { query: "turn_max_gteq:200",                    }, },
      { name: "50手未満",                 params: { query: "turn_max_lt:50",                       }, },
      { name: "駒落ち",                   params: { query: "tag:駒落ち",                           }, },
      { name: "指導対局",                 params: { query: "tag:指導対局",                         }, },
      { name: "駒柱",                     params: { query: "tag:駒柱",                             }, },
      { name: "鬼殺し",                   params: { query: "tag:鬼殺し",                           }, },
      { name: "端棒銀 vs 振り飛車",       params: { query: "tag:端棒銀 tag:振り飛車",              }, },
      { name: "右四間飛車 vs 四間飛車",   params: { query: "tag:右四間飛車 tag:四間飛車",          }, },
      { name: "嬉野流 vs 三間飛車",       params: { query: "tag:嬉野流 tag:三間飛車",              }, },
      { name: "嬉野流 vs 四間飛車",       params: { query: "tag:嬉野流 tag:四間飛車",              }, },
      { name: "嬉野流 vs ゴキゲン中飛車", params: { query: "tag:嬉野流 tag:ゴキゲン中飛車",        }, },
      { name: "嬉野流 vs 振り飛車",       params: { query: "tag:嬉野流 tag:振り飛車",              }, },
      { name: "四段〜九段",               params: { query: "or_tag:四段,五段,六段,七段,八段,九段", }, },
      { name: "初段〜三段",               params: { query: "or_tag:初段,二段,三段",                }, },
      { name: "初段",                     params: { query: "or_tag:初段",                          }, },

      # { name: "手数多い順",             params: { sort_column: :turn_max, sort_order: :desc,  }, },
      # { name: "手数少ない順",           params: { sort_column: :turn_max, sort_order: :asc,   }, },
    ]
  end
end
