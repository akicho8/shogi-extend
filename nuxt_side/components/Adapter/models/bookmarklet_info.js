import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class BookmarkletInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      {
        name: "なんでも棋譜変換",
        description: "なんでも棋譜変換に貼り付けるだけです",
        func(context) {
          return `window.open(\`${context.adapter_url}?body=\${location.href}\`, '_blank')`
        },
      },
      {
        name: "KENTO起動",
        description: "なんでも棋譜変換に貼り付けたあとKENTOボタンを押します",
        func(context) {
          return `window.open(\`${context.adapter_url}?body=\${location.href}&app_to=kento\`, '_blank')`
        },
      },
    ]
  }
}
