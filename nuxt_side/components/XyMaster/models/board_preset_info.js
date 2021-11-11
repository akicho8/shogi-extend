import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class BoardPresetInfo extends ApplicationMemoryRecord {
  static field_label = "盤面"
  static field_message = ""

  static get define() {
    return [
      { key: "空",   sfen: "position sfen 9/9/9/9/9/9/9/9/9 b - 1",                                         },
      { key: "平手", sfen: "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1", },
    ]
  }
}
