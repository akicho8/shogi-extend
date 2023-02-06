import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class TimeChartZoomInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "zoom_minus", name: "-", },
      { key: "zoom_plus",  name: "+", },
    ]
  }
}
