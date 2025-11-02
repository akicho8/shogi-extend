import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class NetLevelInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { name: "C-", threshold: 0.27, }, // C帯は差:4
      { name: "C",  threshold: 0.23, },
      { name: "C+", threshold: 0.19, },
      { name: "B-", threshold: 0.15, }, // B帯は差:3
      { name: "B",  threshold: 0.12, },
      { name: "B+", threshold: 0.09, },
      { name: "A-", threshold: 0.06, }, // A帯は差:2
      { name: "A",  threshold: 0.04, },
      { name: "A+", threshold: 0.02, },
      { name: "S",  threshold: 0.01, }, // S帯は差:1
      { name: "S+", threshold: 0.00, },
    ]
  }
}
