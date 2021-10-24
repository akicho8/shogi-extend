import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class AbstractViewpointInfo extends ApplicationMemoryRecord {
  // static field_label = "(field_label)"
  // static field_message = "(field_message)"
  static get define() {
    return [
      { key: "black",    name: "常に☗ (詰将棋向け)",                                       },
      { key: "white",    name: "常に☖ (逃れ将棋向け)",                                     },
      { key: "self",     name: "1手指し継いだとき自分の視点 (リレー将棋のときのおすすめ)", },
      { key: "opponent", name: "1手指し継いだとき相手の視点 (リレー将棋向け)",             },
    ]
  }
}
