import _ from "lodash"
import { Gs } from "@/components/models/gs.js"

export const mod_room_key_autocomplete = {
  methods: {
    room_key_autocomplete_select_handle() {
    },

    room_key_autocomplete_enter_handle() {
    },

    // room_key を complement_room_keys (localStorage) に保存する
    room_keys_update_and_save_to_storage() {
      if (Gs.present_p(this.room_key)) {
        let av = [this.room_key, ...this.complement_room_keys]
        av = _.uniq(av)
        av = _.take(av, this.room_keys_limit)
        this.complement_room_keys = av
      }
    },
  },
  computed: {
    room_key_autocomplete_use_p() { return false }, // b-autocomplete を使うか？

    // b-autocomplete 用の補完リスト
    room_key_autocomplete_complement_list() {
      if (this.complement_room_keys) {
        return this.complement_room_keys.filter(option => {
          const a = option.toString().toLowerCase()
          const b = (this.new_room_key || "").toLowerCase()
          return a.indexOf(b) >= 0
        })
      }
    },
  },
}
