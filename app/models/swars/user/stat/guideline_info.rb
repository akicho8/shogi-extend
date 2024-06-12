# frozen-string-literal: true

module Swars
  module User::Stat
    class GuidelineInfo
      include ApplicationMemoryRecord
      memory_record [
        { weight:  1, key: "必敗ならすべて投了した",         desc: "負けた対局の結末がすべて投了か？",     if_cond: proc { (judge_final_stat.toryo_ratio || 1.0) >= 1.0 }, },
        { weight:  1, key: "敗勢ですぐに投げない",           desc: "負け手数平均が勝ち手数平均より上か？", if_cond: proc { mental_stat.guideline? }, },
        { weight:  1, key: "舐めプ戦法を使っていない",       desc: "穴角の使用が0回か？",                  if_cond: proc { !tag_stat.include?("穴角") }, },
        { weight:  2, key: "無理攻めをしていない",           desc: "大駒全ブッチで負け越している？",       if_cond: proc { !win_stat.exist?(:"大駒全ブッチ") }, },
        { weight:  2, key: "先手で千日手にしていない",       desc: "先手の千日手回数が0回か？",            if_cond: proc { (draw_stat.positive_bad_count || 0).zero? }, },
        { weight:  3, key: "無気力な対局をしていない",       desc: "無気力対局回数が0回か？",              if_cond: proc { (lethargy_stat.count || 0).zero? }, },
        { weight:  4, key: "穴角戦法を使っていない",         desc: "穴角の使用が0回か？",                  if_cond: proc { !tag_stat.include?("穴角") }, },
        { weight:  5, key: "角不成をしていない",             desc: "角不成の回数が0回か？",                if_cond: proc { tag_stat.count_by(:"角不成").zero? }, },
        { weight:  5, key: "飛車不成をしていない",           desc: "飛車不成の回数が0回か？",              if_cond: proc { tag_stat.count_by(:"飛車不成").zero? }, },
        { weight:  6, key: "1手詰を焦らしていない",          desc: "1手詰を焦らした回数が0回か？",         if_cond: proc { mate_stat.count.zero? }, },
        { weight:  7, key: "人に対して棋神を使わない",       desc: "将棋ウォーズの運営を支える力が0か？",  if_cond: proc { fraud_stat.count.zero? }, },
        { weight:  8, key: "適正な棋力の相手と対局している", desc: "段級差平均の絶対値が3未満か？",        if_cond: proc { user.grade_info.teacher ? true : gdiff_stat.abs < 3 }, },
        { weight:  9, key: "対局放棄のような長考をしない",   desc: "最長考が3分以上の対局が0件か？",       if_cond: proc { prolonged_deliberation_stat.count.zero? }, },
        { weight: 10, key: "友達対局で無双していない",       desc: "友達対局の勝率が8割未満か？",          if_cond: proc { xmode_judge_stat.ratio_by_xmode_key(:"友達") < 0.8 }, },
        { weight: 12, key: "切断していない",                 desc: "切断回数が0回か？",                    if_cond: proc { (judge_final_stat.count_by(:lose, :DISCONNECT) || 0).zero? }, },
        { weight: 14, key: "放置していない",                 desc: "放置した回数が0か？",                  if_cond: proc { leave_alone_stat.count.zero? }, },
        { weight: 16, key: "退席待ち狙いをしていない",       desc: "相手の退席を待った回数が0回か？",      if_cond: proc { waiting_to_leave_stat.count.zero? }, },
      ]
    end
  end
end
