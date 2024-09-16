class QuickScript::Swars::PiyoShogiConfigScript
  class PiyoShogiTypeInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :auto,   name: "スマホだけ",          el_message: "スマホしか使ってない人向け (初期値)",               },
      { key: :native, name: "Mac PC でも表示する", el_message: "ぴよ将棋を最近の Mac にインストールしている人向け", },
    ]
  end
end
