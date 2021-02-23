import MemoryRecord from 'js-memory-record'

export class PiyoShogiTypeInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "auto",   name: "自動判別",   message: "基本こちらでよい",                                                              },
      { key: "native", name: "ぴよ将棋",   message: "M1 Mac に「ぴよ将棋」を入れたのに「ぴよ将棋ｗ」が起動して困っている人はこちら", },
      { key: "web",    name: "ぴよ将棋ｗ", message: "なんかしらの理由でアプリ版を入れられない人はこちら",                            },
    ]
  }
}
