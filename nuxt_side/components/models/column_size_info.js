import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { ColumnSizeAllInfo } from './column_size_all_info.js'

export class ColumnSizeInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "is_size_2", },
      { key: "is_size_3", },
      { key: "is_size_4", },
      { key: "is_size_6", },
    ]
  }

  get column_class() {
    return ColumnSizeAllInfo.fetch(this.key).column_class
  }
}
