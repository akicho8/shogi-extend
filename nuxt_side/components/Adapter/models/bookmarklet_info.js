import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

const BODY_VALUE = "encodeURIComponent(getSelection().toString() || location.href)"

export class BookmarkletInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      {
        name: "なんでも棋譜変換",
        title: "選択範囲か現在のURLをなんでも棋譜変換に放り込む",
        func(context) {
          return `open(\`${context.adapter_url}?body=\${${BODY_VALUE}}\`, '_blank')`
        },
      },
      {
        name: "なんでもぴよ将棋",
        title: "放り込んでからぴよ将棋で開く",
        func(context) {
          return `open(\`${context.adapter_url}?body=\${${BODY_VALUE}}&open=piyo_shogi&open_target=_self\`, '_blank')`
        },
      },
      {
        name: "なんでもKENTO",
        title: "放り込んでからKENTOで開く",
        func(context) {
          return `open(\`${context.adapter_url}?body=\${${BODY_VALUE}}&open=kento&open_target=_self\`, '_blank')`
        },
      },
      {
        name: "なんでも棋譜コピー",
        title: "放り込んでから棋譜をクリップボードにコピーする",
        description: "ブラウザが自動化を阻止してくるのできっと動かないでしょう",
        func(context) {
          return `open(\`${context.adapter_url}?body=\${${BODY_VALUE}}&open=clipboard\`, '_blank')`
        },
      },
      {
        name: "なんでも共有将棋盤",
        title: "放り込んでから共有将棋盤で開く",
        func(context) {
          return `open(\`${context.adapter_url}?body=\${${BODY_VALUE}}&open=share_board\`, '_blank')`
        },
      },
      {
        name: "なんでも共有将棋盤(詰将棋用)",
        title: "放り込んでから初期配置の局面で共有将棋盤を開く",
        func(context) {
          return `open(\`${context.adapter_url}?body=\${${BODY_VALUE}}&open=share_board&turn=0\`, '_blank')`
        },
      },
      {
        name: "なんでも動画作成",
        title: "放り込んでから動画作成を開く",
        func(context) {
          return `open(\`${context.adapter_url}?body=\${${BODY_VALUE}}&open=video_new\`, '_blank')`
        },
      },
      {
        name: "なんでも棋譜印刷",
        title: "放り込んでから棋譜印刷確認画面を開く",
        func(context) {
          return `open(\`${context.adapter_url}?body=\${${BODY_VALUE}}&open=print\`, '_blank')`
        },
      },
    ]
  }
}
