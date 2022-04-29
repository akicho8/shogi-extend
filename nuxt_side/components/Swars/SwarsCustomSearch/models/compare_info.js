import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class CompareInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "gteq", name: "以上",   value: ">=",  type: "is-primary", message: null, },
      { key: "lteq", name: "以下",   value: "<=",  type: "is-primary", message: null, },
      { key: "gt",   name: "より上", value: ">",   type: "is-primary", message: null, },
      { key: "eq",   name: "一致",   value: "==",  type: "is-primary", message: null, },
      { key: "lt",   name: "より下", value: "<",   type: "is-primary", message: null, },
    ]
  }
}
