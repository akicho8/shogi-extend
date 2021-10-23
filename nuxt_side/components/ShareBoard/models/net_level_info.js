import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class NetLevelInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { name: "最悪",         threshold: 0.50, },
      { name: "めっちゃ悪い", threshold: 0.40, },
      { name: "悪い",         threshold: 0.30, },
      { name: "やや悪い",     threshold: 0.20, },
      { name: "やや良い",     threshold: 0.10, },
      { name: "良い",         threshold: 0.05, },
      { name: "めっちゃ良い", threshold: 0.01, },
      { name: "最高",         threshold: 0.00, },
    ]
  }
}
