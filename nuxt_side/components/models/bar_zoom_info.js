import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class BarZoomInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "bz_is_small", datalabels_display: false, aspect_ratio: 3.0, },
      { key: "bz_is_large", datalabels_display: true,  aspect_ratio: 2.0, },
    ]
  }
}
