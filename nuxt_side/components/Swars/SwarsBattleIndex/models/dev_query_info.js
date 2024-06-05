// 対象者の履歴が空の場合
// ・404だった
// ・しばらくウォーズを利用していないせいで履歴が空だった
// の判別はしていない

import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class DevQueryInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { name: "棋譜の取得 (初回)",        params: { query: "YamadaTaro", x_destroy_all: true, throttle_cache_clear: true,                                }, },
      { name: "棋譜の取得 (再度)",        params: { query: "YamadaTaro",                                                                                 }, },
      { name: "クエリを指定しない",       params: { query: "",                                                                                           }, },
      { name: "棋譜の不整合が起きた",     params: { query: "YamadaTaro", x_destroy_all: true, throttle_cache_clear: true, bs_error_capture_fake: true,   }, },
      { name: "本家の形式が変更になった", params: { query: "YamadaTaro", x_destroy_all: true, throttle_cache_clear: true, SwarsFormatIncompatible: true, }, },
      { name: "本家に接続できない",       params: { query: "YamadaTaro", x_destroy_all: true, throttle_cache_clear: true, RaiseConnectionFailed: true,   }, },
      { name: "対象者の履歴が空だった※", params: { query: "YamadaTaro", x_destroy_all: true, throttle_cache_clear: true, SwarsUserNotFound: true,       }, },
      { name: "対象の対局がなかった",     params: { query: "YamadaTaro", x_destroy_all: true, throttle_cache_clear: true, SwarsBattleNotFound: true,     }, },
      { name: "▲を左に表示",             params: { query: "YamadaTaro", viewpoint: "black",                                                             }, },
      { name: "△を左に表示",             params: { query: "YamadaTaro", viewpoint: "white",                                                             }, },
      { name: "全レコード表示",           params: { query: "",           all: true, per: 50, badge_debug: true,                                          }, },
    ]
  }
}
