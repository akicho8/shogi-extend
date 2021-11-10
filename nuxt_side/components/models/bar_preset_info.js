import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class BarPresetInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "bp_is_default", datalabels_display: false, aspect_ratio: 3.0, },
      { key: "bp_is_detail",  datalabels_display: true,  aspect_ratio: 2.0, },
    ]
  }
}
