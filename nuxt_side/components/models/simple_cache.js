// 普通のキャッシュだが axios を経由したときクリップボードへのコピーに失敗する対策のために用意した
//
// 使用例
//
//  async any_method(url) {
//    const key = GX.str_to_md5(url)
//
//    // 1回目
//    if (simple_cache.empty_p(key)) {
//      this.debug_alert("APIアクセス発生")
//      simple_cache.write(key, await this.$axios.$get(url))
//    }
//
//    // 1,2回目
//    return this.clipboard_copy(simple_cache.read(key))
//  },
//
// 本当は次のように書きたいがそうすると cache に Promise オブジェクトが入ってしまう(どうすれば？)
//
//  async any_method(url) {
//    const url = await simple_cache.fetch(url, async () => await this.$axios.$get(url))
//    return this.clipboard_copy(url)
//  }
//
import { GX } from "@/components/models/gs.js"

export class SimpleCache {
  constructor() {
    this.cache = {}
  }

  fetch(key, block = () => {}) {
    GX.assert(key != null, "key != null")
    if (this.exist_p(key)) {
      return this.read(key)
    }
    this.write(key, block())
    return this.read(key)
  }

  write(key, value) {
    GX.assert(key != null, "key != null")
    this.cache[key] = value
  }

  read(key) {
    GX.assert(key != null, "key != null")
    return this.cache[key]
  }

  delete(key) {
    GX.assert(key != null, "key != null")
    delete this.cache[key]
  }

  // key in this.cache で判定する方法は逆に扱いにくいため値で判定する
  exist_p(key) {
    GX.assert(key != null, "key != null")
    return this.read(key) != null
  }

  empty_p(key) {
    GX.assert(key != null, "key != null")
    return this.read(key) == null
  }
}
