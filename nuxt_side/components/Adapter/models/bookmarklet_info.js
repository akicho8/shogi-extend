import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class BookmarkletInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      {
        name: "なんでも棋譜変換",
        description: "いま参照しているURLをなんでも棋譜変換に放り込むだけ",
        func(context) {
          return `window.open(\`${context.adapter_url}?body=\${location.href}\`, '_blank')`
        },
      },
      {
        name: "ぴよ将棋",
        description: "放り込んでからぴよ将棋に渡す",
        func(context) {
          return `window.open(\`${context.adapter_url}?body=\${location.href}&app_to=piyo_shogi\`, '_blank')`
        },
      },
      {
        name: "KENTO",
        description: "放り込んでからKENTOに渡す",
        func(context) {
          return `window.open(\`${context.adapter_url}?body=\${location.href}&app_to=kento\`, '_blank')`
        },
      },
      {
        name: "棋譜コピー",
        description: "放り込んでから棋譜をクリップボードに渡す",
        func(context) {
          return `window.open(\`${context.adapter_url}?body=\${location.href}&app_to=clipboard\`, '_blank')`
        },
      },
      {
        name: "共有将棋盤",
        description: "放り込んでから共有将棋盤に渡す",
        func(context) {
          return `window.open(\`${context.adapter_url}?body=\${location.href}&app_to=share_board\`, '_blank')`
        },
      },
    ]
  }
}
