import _ from "lodash"
import { Gs } from "@/components/models/gs.js"

export const mod_room_setup_modal_autocomp = {
  data() {
    return {
    }
  },
  mounted() {
  },
  beforeDestroy() {
  },
  methods: {
    rsm_autocomp_select_handle() {
    },

    rsm_autocomp_enter_handle() {
    },

    // room_key を room_keys (localStorage) に保存する
    room_keys_update_and_save_to_storage() {
      if (Gs.present_p(this.room_key)) {
        let av = [this.room_key, ...this.room_keys]
        av = _.uniq(av)
        av = _.take(av, this.room_keys_limit)
        this.room_keys = av
      }
    },
  },
  computed: {
    rsm_autocomp_use_p() { return false }, // b-autocomplete を使うか？

    // b-autocomplete 用の補完リスト
    rsm_autocomp_data() {
      if (this.room_keys) {
        return this.room_keys.filter(option => {
          const a = option.toString().toLowerCase()
          const b = (this.new_room_key || "").toLowerCase()
          return a.indexOf(b) >= 0
        })
      }
    },
  },
}
