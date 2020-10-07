import _ from "lodash"
import dayjs from "dayjs"
import MemoryRecord from 'js-memory-record'

import SwarsBattleIndexTableColumn from "./SwarsBattleIndexTableColumn.js"

import SwarsBattleIndexSearchAction from "./SwarsBattleIndexSearchAction.js"
import ls_support from "@/components/models/ls_support.js"

export default {
  mixins: [
    SwarsBattleIndexTableColumn,
    SwarsBattleIndexSearchAction,
    ls_support,
  ],

  data() {
    return {
      display_key: null, // 何の局面の表示をするか？
    }
  },

  methods: {
    show_handle(row) {
      this.jump_to_battle(row.key, {display_key: this.display_key})
    },

    // 開始局面
    // force_turn start_turn critical_turn の順に見る
    sp_start_turn(record) {
      if (this.display_key === "last") {
        return record.turn_max
      }
      return record.display_turn
    },

    piyo_shogi_app_with_params_url(record) {
      return this.piyo_shogi_auto_url({path: record.show_path, sfen: record.sfen_body, turn: this.sp_start_turn(record), flip: record.flip, ...record.piyo_shogi_base_params})
    },

    kento_app_with_params_url(record) {
      return this.kento_full_url({sfen: record.sfen_body, turn: this.sp_start_turn(record), flip: record.flip})
    },
  },

  computed: {
    //////////////////////////////////////////////////////////////////////////////// ls_support

    ls_storage_key() {
      return "swars/battles/index"
    },

    ls_default() {
      return {
        visible_hash: this.as_visible_hash(this.config.table_columns_hash),
        display_key:  this.config.display_key,
      }
    },

    ////////////////////////////////////////////////////////////////////////////////
  },
}
