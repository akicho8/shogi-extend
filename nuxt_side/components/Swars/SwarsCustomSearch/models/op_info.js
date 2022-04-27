import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class OpInfo extends ApplicationMemoryRecord {
  static field_label = ""
  static field_message = null

  static get define() {
    return [
      { key: "gteq", name: "以上",   value: ">=",  type: "is-primary", message: null, },
      // { key: "gt",   name: "より上", value: ">",   type: "is-primary", message: null, },
      // { key: "eq",   name: "通常",   value: "==",  type: "is-primary", message: null, },
      { key: "lteq", name: "以下",   value: "<=",  type: "is-primary", message: null, },
      // { key: "lt",   name: "指導",   value: "<",   type: "is-primary", message: null, },
    ]
  }

  // get to_query_part() {
  //   if (this.key != "none") {
  //     return `対局モード:${this.key}`
  //   }
  // }
}
