import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class TimeChartVariantInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "tcv_normal",    name: "明細", },
      { key: "tcv_accretion", name: "累積", },
    ]
  }
}
