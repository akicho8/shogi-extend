import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { GX } from "@/components/models/gx.js"

export class TabDupInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "td_tab", name: "タブ重複", subject: "アクセス重複",       message: "<p>複数のタブから同時にアクセスしています</p><p>他のタブを閉じて一カ所だけからアクセスするようにしてください</p>",                                                           },
      { key: "td_pc",  name: "PC重複",   subject: "ハンドルネーム重複", message: "<p>別のブラウザまたは別のPCから同じハンドルネームで同時にアクセスしている人がいます</p><p>一カ所だけからアクセスするようにするか、干渉しないようにハンドルネームを変更してください</p>", },
    ]
  }

  get talk_body() {
    const str = [this.subject, this.message].join("。")
    return str.replaceAll("</p>", "。</p>")
  }
}
