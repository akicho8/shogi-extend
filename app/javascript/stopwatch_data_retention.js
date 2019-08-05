// URL または localStorage にデータを永続化保存する機能
//
// save_hash
// local_storage_key
// data_restore_from_hash

import { LZMA } from "lzma/src/lzma_worker.js"
import * as UrlSafeBase64 from "url-safe-base64"

export default {
  created() {
    this.data_restore_from_url_or_storage()
  },

  methods: {
    data_save() {
      location.hash = this.enc_base64
      localStorage.setItem(this.local_storage_key, this.enc_base64)
    },

    data_restore_from_url_or_storage() {
      let enc_base64 = null
      if (location.hash) {
        enc_base64 = location.hash.replace(/^#/, "")
      } else {
        enc_base64 = localStorage.getItem(this.local_storage_key)
      }
      this.data_restore_from_base64(enc_base64)
    },

    data_restore_from_base64(enc_base64) {
      let dec_params = {}
      if (enc_base64) {
        try {
          const dec_string = atob(UrlSafeBase64.decode(enc_base64))
          const dec_json = LZMA.decompress(dec_string.split("").map(c => c.charCodeAt(0)))
          dec_params = JSON.parse(dec_json)
        } catch (e) {
          console.error(e)
        }
      }
      this.data_restore_from_hash(dec_params || {})
    },

    data_restore_from_hash(hash) {
      alert("data_restore not implemented")
    },
  },

  computed: {
    save_hash() {
      alert("save_hash not implemented")
    },

    permalink() {
      return `${window.location.href}#${this.enc_base64}`
    },

    enc_base64() {
      const enc_json = JSON.stringify(this.save_hash)
      const compressed = LZMA.compress(enc_json, 9)
      const enc_string = String.fromCharCode(...new Uint8Array(compressed))
      const enc_base64 = UrlSafeBase64.encode(btoa(enc_string))
      return enc_base64
    },

    local_storage_key() {
      return "dc6c1cd5cf94742da55c164d1b625d22"
    },
  },
}
