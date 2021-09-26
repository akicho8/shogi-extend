import MemoryRecord from 'js-memory-record'

export class SearchPresetInfo extends MemoryRecord {
  static get define() {
    return [
      { name: "すべて",   tag: "",                    scope: "",        },
      { name: "居飛車",   tag: "居飛車",              scope: "",        },
      { name: "振り飛車", tag: "振り飛車",            scope: "",        },
      // { name: "右玉",     tag: this.migigyoku_family, scope: "",        },
      { name: "公開",     tag: "",                    scope: "public",  },
      { name: "限定公開", tag: "",                    scope: "limited", },
      { name: "非公開",   tag: "",                    scope: "private", },
    ]
  }

  static get migigyoku_family() {
    return [
      "矢倉右玉",
      "右玉",
      "糸谷流右玉",
      "羽生流右玉",
      "角換わり右玉",
      "雁木右玉",
      "ツノ銀型右玉",
      "三段右玉",
      "清野流岐阜戦法",
    ].join(",")
  }

  get to_params() {
    return {
      tag: this.tag,
      scope: this.scope,
    }
  }
}
