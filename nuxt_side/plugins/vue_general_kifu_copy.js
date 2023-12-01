import { Gs } from "@/components/models/gs.js"
import { SimpleCache } from "@/components/models/simple_cache.js"

// 2回目のコピーでコピーを成功させるか？
// iOS では axios でサーバー通信した直後にクリップボードに入れようとするとなぜか失敗する
// そのため1回目で失敗したときにキャッシュしておき、2度目で axios のアクセスが発声しないようにすることでコピーを成功させる
const IOS_CLIPBOARD_BUG_THAT_FAILS_WITH_AXIOS_WORKAROUND = true

const simple_cache = new SimpleCache()

export const vue_general_kifu_copy = {
  methods: {
    // 棋譜を渡して指定フォーマットにしたものをコピーする
    // general_kifu_copy(sfen, {to_format: "kif"})
    async general_kifu_copy(any_source, options = {}) {
      options = {
        candidate_enable: true, // KI2 の場合 true にしないとエラーになる
        validate_enable: false,
        any_source: any_source,
        ...options,
      }
      options.to_format = options.to_format || "kif"

      const key = this.__general_kifu_copy_key(any_source, options)

      // 2回目(read)
      if (IOS_CLIPBOARD_BUG_THAT_FAILS_WITH_AXIOS_WORKAROUND) {
        if (simple_cache.exist_p(key)) {
          return this.clipboard_copy(simple_cache.read(key))
        }
      }

      // 1回目(write)
      const body = await this.__general_kifu_copy_axios(options)
      if (body) {
        simple_cache.write(key, body)
        return this.clipboard_copy(body)
      }
    },
    __general_kifu_copy_axios(options = {}) {
      this.debug_alert("APIアクセス発生")
      return this.$axios.$post("/api/general/any_source_to.json", options).then(e => {
        this.bs_error_message_dialog(e)
        if (e.body) {
          return e.body
        }
      })
    },
    __general_kifu_copy_key(any_source, options) {
      // BODをコピーするときだけ turn が入っているので一応キーに含める
      const str = [any_source, options.to_format, (options.turn ?? "")].join("/")
      return Gs.str_to_md5(str)
    },

    // 指定 URL の結果をクリップボードにコピーする
    // 前回取得したテキストを保存し2度目はリクエストしない
    // 成功したら true を返す
    //
    // 本当は次のように書きたいが、そうすると Promise オブジェクトがキャッシュに入ってしまって
    // わけがわからんことになるので冗長だが read write に分けて書くことにした
    //
    //   async kif_clipboard_copy_from_url(url) {
    //     const key = Gs.str_to_md5(url)
    //     const body = simple_cache.fetch(key, async () => {
    //       return await this.$axios.$get(url)
    //     })
    //     return this.clipboard_copy(body)
    //   },
    //
    async kif_clipboard_copy_from_url(url) {
      const key = Gs.str_to_md5(url)

      // 2回目(read)
      if (IOS_CLIPBOARD_BUG_THAT_FAILS_WITH_AXIOS_WORKAROUND) {
        if (simple_cache.exist_p(key)) {
          const body = simple_cache.read(key)
          return this.clipboard_copy(body)
        }
      }

      // 1回目(write)
      this.debug_alert("APIアクセス発生")
      const body = await this.$axios.$get(url)
      simple_cache.write(key, body)
      return this.clipboard_copy(body)
    },
  },
}
