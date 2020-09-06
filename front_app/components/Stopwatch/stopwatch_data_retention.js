// URL または localStorage にデータを永続化保存する機能
//
// $_ls_hash
// ls_key
// data_restore_from_hash

import { LZMA } from "lzma/src/lzma_worker.js"
import * as UrlSafeBase64 from "url-safe-base64"

export default {
  created() {
    this.data_restore_from_url_or_storage()
  },

  methods: {
    // hashに埋めたくなくなったので未使用
    data_save() {
      this.data_save_to_location_hash()
      this.data_save_to_local_storage()
    },

    data_save_to_location_hash() {
      location.hash = this.enc_base64
    },

    data_save_to_local_storage() {
      localStorage.setItem(this.ls_key, this.enc_base64)
    },

    storage_clear() {
      localStorage.removeItem(this.ls_key)
    },

    data_restore_from_url_or_storage() {
      let enc_base64 = null

      if (this.$route.query.restore_code) {
        enc_base64 = this.$route.query.restore_code
      } else if (location.hash) {
        enc_base64 = location.hash.replace(/^#/, "")
      } else {
        enc_base64 = localStorage.getItem(this.ls_key)
      }

      this.data_restore_from_base64(enc_base64)
      this.data_restore_from_url_or_storage_after_hook()
    },

    // 本体の方でオーバーライドしている
    data_restore_from_url_or_storage_after_hook() {
      // URL から hash を除いたURLにしたいとき
      // if (location.hash) {
      //   location.href = this.location_url_without_hash()
      // }
    },

    data_restore_from_base64(enc_base64) {
      const value = this.base64_to_value(enc_base64)
      this.data_restore_from_hash(value || {})
    },

    data_restore_from_hash(hash) {
      alert("data_restore not implemented")
    },

    value_to_base64(value) {
      const enc_json = JSON.stringify(value)
      const compressed = LZMA.compress(enc_json, 9)
      const enc_string = String.fromCharCode(...new Uint8Array(compressed))
      const enc_base64 = UrlSafeBase64.encode(btoa(enc_string))
      return enc_base64
    },

    base64_to_value(enc_base64) {
      if (typeof window !== 'undefined') {
        return {}
      }

      let value = null
      try {
        const dec_string = atob(UrlSafeBase64.decode(enc_base64))
        const dec_json = LZMA.decompress(dec_string.split("").map(c => c.charCodeAt(0)))
        value = JSON.parse(dec_json)
      } catch (e) {
        console.error(e)
      }
      return value
    },
  },

  computed: {
    $_ls_hash() {
      alert("$_ls_hash not implemented")
    },

    permalink_url() {
      if (process.client) {
        // reload=1 に意味はないが現在のURLと異なるようにすることで、ストップウォッチにいる状態でリンクを踏んだときに新しいURLに飛ぶようにする
        // そうしないとブックマークからリンクしたときに遷移しない
        // return `${this.location_url_without_search_and_hash()}?reload=1#${this.enc_base64}`
        return `${this.location_url_without_search_and_hash()}?restore_code=${this.enc_base64}`
      }
    },

    enc_base64() {
      return this.value_to_base64(this.$_ls_hash)
    },

    ls_key() {
      return "dc6c1cd5cf94742da55c164d1b625d22"
    },
  },
}
