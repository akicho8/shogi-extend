import { GX } from "@/components/models/gs.js"
import { SimpleCache } from "@/components/models/simple_cache.js"

const simple_cache = new SimpleCache()

export const vue_general_kifu_copy = {
  methods: {
    // 棋譜を渡して指定フォーマットにしたものをコピーする
    // general_kifu_copy(sfen, {to_format: "kif"})
    async general_kifu_copy(any_source, options = {}) {
      options = {
        ki2_function: true, // KI2 の場合 true にしないとエラーになる
        validate_feature: false,
        analysis_feature: false,
        any_source: any_source,
        ...options,
      }
      options.to_format = options.to_format || "kif"

      const key = this.__general_kifu_copy_key(any_source, options)

      // 1回目
      if (simple_cache.empty_p(key)) {
        simple_cache.write(key, await this.__general_kifu_copy_axios(options))
      }

      // 1, 2回目
      return this.clipboard_copy(simple_cache.read(key))
    },
    __general_kifu_copy_axios(options = {}) {
      // this.clog("APIアクセス発生")
      return this.$axios.$post("/api/general/any_source_to.json", options).then(e => {
        // this.clog("APIアクセス結果")
        this.bs_error_message_dialog(e)
        if (e.body) {
          return e.body
        }
      })
    },
    __general_kifu_copy_key(any_source, options) {
      // BODをコピーするときだけ turn が入っているので一応キーに含める
      const str = [any_source, options.to_format, (options.turn ?? "")].join("/")
      return GX.str_to_md5(str)
    },

    // 指定 URL の結果をクリップボードにコピーする
    // 前回取得したテキストを保存し2度目はリクエストしない
    // 成功したら true を返す
    //
    // 本当は次のように書きたいが、そうすると Promise オブジェクトがキャッシュに入ってしまって
    // わけがわからんことになるので冗長だが read write に分けて書くことにした
    //
    //   async kif_clipboard_copy_from_url(url) {
    //     const key = GX.str_to_md5(url)
    //     const body = simple_cache.fetch(key, async () => {
    //       return await this.$axios.$get(url)
    //     })
    //     return this.clipboard_copy(body)
    //   },
    //
    async kif_clipboard_copy_from_url(url) {
      const key = GX.str_to_md5(url)

      // 1回目
      if (simple_cache.empty_p(key)) {
        // this.clog("APIアクセス発生")
        simple_cache.write(key, await this.$axios.$get(url))
      }

      // 1,2回目
      return this.clipboard_copy(simple_cache.read(key))
    },
  },
}
