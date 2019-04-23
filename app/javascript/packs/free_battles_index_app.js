import _ from "lodash"
import * as AppHelper from "./app_helper.js"
import axios from "axios"

window.FreeBattlesIndexApp = Vue.extend({
  data() {
    return {
      query: this.$options.query,
      records: this.$options.records,
      modal_p: false,
      current_id: null,
    }
  },

  methods: {
    ositazo(id) {
      this.modal_p = true
      this.current_id = id
    },
  },

  computed: {
    records_hash() {
      return this.records.reduce((a, e, i) => ({...a, [e.id]: {code: i, ...e}}), {})
    },

    current_record() {
      return this.records_hash[this.current_id]
    },

    current_record_sfen() {
      if (this.current_record) {
        return this.current_record.sfen
      }
    },

    current_record_card_title() {
      if (this.current_record) {
        return this.current_record.title
      }
    },
  },
})
