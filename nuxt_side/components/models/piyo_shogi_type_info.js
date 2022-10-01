import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { isMobile } from "@/components/models/is_mobile.js"

export class PiyoShogiTypeInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "auto",   name: "自動判別",   message: "一般的なスマホやPCを使っている人向け",                                                                           func: () => isMobile.iOS() || isMobile.Android(), },
      { key: "native", name: "ぴよ将棋",   message: "M1 Mac に「ぴよ将棋」を入れたのに「ぴよ将棋ｗ」が起動して困っている人向け",                                      func: () => true,                                 },
      { key: "web",    name: "ぴよ将棋ｗ", message: "スマホになんかしらの制約で「ぴよ将棋」を入れられなかったり「ぴよ将棋」があるのに「ぴよ将棋ｗ」を使いたい人向け", func: () => false,                                },
    ]
  }
}
