class QuickScript::Swars::BattleDownloadScript
  class MaxInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "1",   name: "1",   value: 1,   el_message: "1件なら対局詳細からダウンロードした方がZIPにならないぶん簡単です", },
      { key: "50",  name: "50",  value: 50,  el_message: "50件取得する",                                                     },
      { key: "100", name: "100", value: 100, el_message: "100件取得する",                                                    },
      { key: "200", name: "200", value: 200, el_message: "201件以上取得するときは「古い棋譜の補完」のほうを使ってください",  },
    ]
  end
end
