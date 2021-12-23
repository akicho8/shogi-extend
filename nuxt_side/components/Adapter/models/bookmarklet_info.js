import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

const BODY_VALUE = "getSelection().toString() || location.href"

export class BookmarkletInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      {
        name: "棋譜変換",
        title: "選択テキストかURLをなんでも棋譜変換に放り込む",
        func(context) {
          return `open(\`${context.adapter_url}?body=\${${BODY_VALUE}}\`, '_blank')`
        },
      },
      {
        name: "ぴよ将棋",
        title: "放り込んでからぴよ将棋で開く",
        func(context) {
          return `open(\`${context.adapter_url}?body=\${${BODY_VALUE}}&open=piyo_shogi&open_target=_self\`, '_blank')`
        },
      },
      {
        name: "KENTO",
        title: "放り込んでからKENTOで開く",
        func(context) {
          return `open(\`${context.adapter_url}?body=\${${BODY_VALUE}}&open=kento&open_target=_self\`, '_blank')`
        },
      },
      {
        name: "棋譜コピー",
        title: "放り込んでから棋譜をクリップボードにコピー",
        description: "ブラウザが嫌がらせで自動化を邪魔してくるのでだいたい動かない",
        func(context) {
          return `open(\`${context.adapter_url}?body=\${${BODY_VALUE}}&open=clipboard\`, '_blank')`
        },
      },
      {
        name: "共有将棋盤",
        title: "放り込んでから共有将棋盤で開く",
        func(context) {
          return `open(\`${context.adapter_url}?body=\${${BODY_VALUE}}&open=share_board\`, '_blank')`
        },
      },
      {
        name: "動画作成",
        title: "放り込んでから動画作成を開く",
        func(context) {
          return `open(\`${context.adapter_url}?body=\${${BODY_VALUE}}&open=video_new\`, '_blank')`
        },
      },
    ]
  }
}
