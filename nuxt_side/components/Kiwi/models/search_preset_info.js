import MemoryRecord from 'js-memory-record'

export class SearchPresetInfo extends MemoryRecord {
  static get define() {
    return [
      { name: "すべて",   tag: "",         scope: "",        },
      { name: "居飛車",   tag: "居飛車",   scope: "",        },
      { name: "振り飛車", tag: "振り飛車", scope: "",        },
      { name: "公開",     tag: "",         scope: "public",  },
      { name: "限定公開", tag: "",         scope: "limited", },
      { name: "非公開",   tag: "",         scope: "private", },
    ]
  }

  get to_params() {
    return {
      tag: this.tag,
      scope: this.scope,
    }
  }
}
