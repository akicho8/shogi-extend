import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ViewpointFlipInfo extends ApplicationMemoryRecord {
  static field_label = "視点を反転"

  static get define() {
    return [
      { key: "flip_off", name: "しない", },
      { key: "flip_on",  name: "する",   },
    ]
  }
}
