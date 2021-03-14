import MemoryRecord from 'js-memory-record'

export class WkbkConfig extends MemoryRecord {
  static get define() {
    return [
      { key: "per_page",          value: 50,                                    },
      { key: "top_tag_display_p", value: process.env.NODE_ENV !== "production", },
    ]
  }
}
