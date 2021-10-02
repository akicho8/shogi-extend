import MemoryRecord from 'js-memory-record'

export class SearchPresetInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "新着",     },
      { key: "視聴数",   },
      { key: "居飛車",   },
      { key: "振り飛車", },
      { key: "右玉",     },
      { key: "履歴",     },
      { key: "公開",     },
      { key: "限定公開", },
      { key: "非公開",   },
    ]
  }
}
