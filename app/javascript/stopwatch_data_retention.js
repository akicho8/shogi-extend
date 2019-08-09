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
    },

    data_save_to_location_hash() {
      location.hash = this.enc_base64
    },

    data_save_to_local_storage() {
      localStorage.setItem(this.local_storage_key, this.enc_base64)
    },

    storage_clear() {
      localStorage.removeItem(this.local_storage_key)
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
    save_hash() {
      alert("save_hash not implemented")
    },

    permalink() {
      return `${window.location.href}#${this.enc_base64}`
    },

    enc_base64() {
      return this.value_to_base64(this.save_hash)
    },

    local_storage_key() {
      return "dc6c1cd5cf94742da55c164d1b625d22"
    },
  },
}
