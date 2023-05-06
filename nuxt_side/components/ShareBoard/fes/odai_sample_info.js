import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { Gs } from "@/components/models/gs.js"
import { Odai } from "./odai.js"

export class OdaiSampleInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { subject: "どっちがお好き？", items: ["マヨネーズ", "ケチャップ"], },
    ]
  }

  static get sample() {
    const record = Gs.ary_sample(this.values)
    if (record) {
      return Odai.create({subject: record.subject, items: record.items})
    }
  }
}
