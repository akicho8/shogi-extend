import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class StatusInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      // ../../../../app/models/lemon.rb
      { key: "失敗",   class: "",                     type: "is-danger is-light",  },
      { key: "成功",   class: "",                     type: "is-success is-light", },
      { key: "待ち",   class: "",                     type: "",                    },
      { key: "変換中", class: "has-text-weight-bold", type: "is-danger is-light",  },
      { key: "完了",   class: "",                     type: "is-primary is-light", },
    ]
  }
}
