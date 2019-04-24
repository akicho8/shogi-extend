import _ from "lodash"
import * as AppHelper from "./app_helper.js"
import axios from "axios"

window.FreeBattleIndex = Vue.extend({
  data() {
    return {
      query: this.$options.query,     // 検索文字列
      records: this.$options.records, // 表示するレコード配列
      modal_p: false,                 // モーダルを開くフラグ
      current_id: null,               // 選択したレコードID
    }
  },

  methods: {
    show_handle(id) {
      this.current_id = id

      if (this.current_record_sp_sfen) {
        this.debug_alert("棋譜はすでにある")
        this.modal_show()
      } else {
        this.debug_alert("新規取得")

        const params = new URLSearchParams()
        if (false) {
          params.append("var1", "1")
        }
        axios({
          method: "get",
          timeout: 1000 * 60 * 10,
          url: this.current_record.get_path,
          data: params,
        }).then(response => {
          const record = this.records.find(e => e.id === this.current_id)
          this.$set(record, "sp_sfen", response.data["sp_sfen"])
          this.modal_show()
        }).catch((error) => {
          console.table([error.response])
          this.$toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
        })
      }
    },

    modal_show() {
      this.modal_p = true
      this.$nextTick(() => document.querySelector(".turn_slider").focus())
    },

    kifu_copy_handle() {
      this.debug_alert(this.current_record.kifu_copy_params)
      AppHelper.kifu_copy_exec(this.current_record.kifu_copy_params)
    },
  },

  mounted() {
    this.$refs.main_field.focus()
  },

  computed: {
    // id ですぐに引けるハッシュ
    records_hash() {
      return this.records.reduce((a, e, i) => ({...a, [e.id]: {code: i, ...e}}), {})
    },

    // current_id に対応するレコード
    current_record() {
      if (this.current_id) {
        return this.records_hash[this.current_id]
      }
    },

    // current_id に対応する sfen
    current_record_sp_sfen() {
      if (this.current_record) {
        return this.current_record.sp_sfen
      }
    },
  },
})
