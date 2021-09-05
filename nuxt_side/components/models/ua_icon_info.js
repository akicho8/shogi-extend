import MemoryRecord from 'js-memory-record'

export class UaIconInfo extends MemoryRecord {
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
