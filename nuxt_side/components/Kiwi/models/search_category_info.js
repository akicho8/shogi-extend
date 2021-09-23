import MemoryRecord from 'js-memory-record'

export class SearchCategoryInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "is_search_category_all",    name: "すべて", tag: "",  },
      { key: "is_search_category_ibisya", name: "居飛車", tag: "b", },
    ]
  }
}
