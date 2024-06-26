import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class SampleMaxInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { value: 0,    environment: ["development"],                          },
      { value: 1,    environment: ["development"],                          },
      { value: 50,   environment: ["development", "staging", "production"], },
      { value: 100,  environment: ["development", "staging", "production"], },
      { value: 200,  environment: ["development", "staging", "production"], },
      { value: 1000, environment: ["development"],                          },
      { value: 2000, environment: ["development"],                          },
      { value: 5000, environment: ["development"],                          },
    ]
  }
  get name() {
    return `直近${this.value}件`
  }
}
