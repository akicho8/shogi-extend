class QuickScript::General::PiyoShogiConfigScript
  class PiyoShogiTypeInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :auto,   name: "スマホだけ", el_message: "スマホしか使ってない人向け (初期値)",                           },
      { key: :native, name: "Mac でも",   el_message: "スマホ用のぴよ将棋を新しめの Mac にインストールしている人向け", },
    ]
  end
end
