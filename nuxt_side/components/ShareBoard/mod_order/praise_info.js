import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class PraiseInfo extends ApplicationMemoryRecord {
  static get define() { return require("./praise_info.definition.js") }
}
