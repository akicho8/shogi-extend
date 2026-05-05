import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { GX } from "@/components/models/gx.js"

export class TabDupInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "td_tab", name: "タブ重複", subject: "タブ干渉",           message: "複数のタブから同時に接続しています<br>他のタブを閉じて一つのタブだけにしてください",                                                           },
      { key: "td_pc",  name: "PC重複",   subject: "ハンドルネーム重複", message: "異なるPCから同じハンドルネームで同時にアクセスしている人がいます<br>一カ所だけからアクセスするようにするか、ハンドルネームを変更してください", },
    ]
  }

  get talk_body() {
    const str = [this.subject, this.message].join("。")
    return str.replaceAll("<br>", "。")
  }
}
