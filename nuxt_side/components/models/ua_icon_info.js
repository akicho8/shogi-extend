import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class UaIconInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "android",          name: "Android", },
      { key: "tablet",           name: "Tablet",  },
      { key: "iphone",           name: "iPhone",  },
      { key: "windows",          name: "Windows", },
      { key: "desktop_computer", name: "Mac",     },
    ]
  }
}
