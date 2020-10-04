import _ from "lodash"
import dayjs from "dayjs"
import MemoryRecord from 'js-memory-record'

import battle_index_table_column from "./battle_index_table_column.js"

import search_form_mod from "./search_form_mod.js"
import ls_support from "@/components/models/ls_support.js"

export default {
  mixins: [
    battle_index_table_column,
    search_form_mod,
    ls_support,
  ],

  data() {
    return {
      board_show_type:  null, // 何の局面の表示をするか？
    }
  },

  methods: {
    show_handle(row) {
      this.jump_to_battle(row.key, {board_show_type: this.board_show_type})
    },

    // 開始局面
    // force_turn start_turn critical_turn の順に見る
    trick_start_turn_for(record) {
      if (this.board_show_type === "last") {
        return record.turn_max
      }
      return record.display_turn
    },

    piyo_shogi_app_with_params_url(record) {
      return this.piyo_shogi_auto_url({path: record.show_path, sfen: record.sfen_body, turn: this.trick_start_turn_for(record), flip: record.flip, ...record.piyo_shogi_base_params})
    },

    kento_app_with_params_url(record) {
      return this.kento_full_url({sfen: record.sfen_body, turn: this.trick_start_turn_for(record), flip: record.flip})
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
      }
    },

    ////////////////////////////////////////////////////////////////////////////////
  },
}
