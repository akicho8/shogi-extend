import MemoryRecord from 'js-memory-record'

export class ArticleTitleDisplayInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "display", name: "する",   },
      { key: "hidden",  name: "しない", },
    ]
  }
}
