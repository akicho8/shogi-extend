<template lang="pug">
.the_ranking
  .primary_header
    .header_center_title ランキング
  .secondary_header
    b-tabs.main_tabs(v-model="tab_index" expanded @change="tab_change_handle")
      template(v-for="tab_info in TabInfo.values")
        b-tab-item.is-size-2(:label="tab_info.name")

  .the_ranking_rows(v-if="rank_data")
    template(v-for="row in rank_data.rank_records")
      the_ranking_row(:row="row")

    template(v-if="!rank_data.user_rank_in || true")
      the_ranking_row.current_user_rank_record(:row="rank_data.current_user_rank_record")
</template>

<script>
import MemoryRecord from 'js-memory-record'

class TabInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "rating",       name: "レーティング", unit: null,     },
      { key: "rensho_count", name: "連勝中",       unit: "連勝中", },
      { key: "rensho_max",   name: "最多連勝数",   unit: "連勝",   },
    ]
  }

  get handle_method_name() {
    return `${this.key}_handle`
  }
}

import support from "./support.js"
import the_ranking_row from "./the_ranking_row.vue"

export default {
  name: "the_ranking",
  mixins: [
    support,
  ],
  components: {
    the_ranking_row,
  },
  props: {
  },
  data() {
    return {
      tab_index: null,
      rank_data: null,
    }
  },

  created() {
    this.app.lobby_close()

    this.sound_play("click")
    this.mode_select("rating")
    this.tab_change_handle()
  },

  watch: {
  },

  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    rating_handle() {
      this.mode_select("rating")
    },

    rensho_count_handle() {
      this.mode_select("rensho_count")
    },

    rensho_max_handle() {
      this.mode_select("rensho_max")
    },

    ////////////////////////////////////////////////////////////////////////////////

    mode_select(tab_key) {
      this.tab_index = TabInfo.fetch(tab_key).code
    },

    tab_change_handle() {
      this[this.current_tab_info.handle_method_name]()
      this.fetch_handle()
    },

    ////////////////////////////////////////////////////////////////////////////////

    fetch_handle() {
      // if (this.rank_records_hash[this.current_tab_info.key]) {
      // } else {
      const params = { ranking_fetch: true, ranking_key: this.current_tab_info.key }
      if (this.development_p) {
        params.take = 5
        params.shuffle = true
      }
      this.http_get_command(this.app.info.put_path, params, e => {
        if (e.rank_data) {
          // this.$set(this.rank_records_hash, e.ranking_key, e.rank_records)
          this.rank_data = e.rank_data
        }
      })
      // }
    },
  },

  computed: {
    TabInfo() { return TabInfo },

    current_tab_info() {
      return TabInfo.fetch(this.tab_index)
    },
    // current_rank_records() {
    //   return this.rank_records_hash[this.current_tab_info.key]
    // },
    // current_user_ranking_record() {
    // },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_ranking
  @extend %padding_top_for_secondary_header

  // 共通化する
  .main_tabs
    a
      height: $actb_primary_header_height
      padding: 0
    .tab-content
      padding: 0

  .current_user_rank_record
    margin-top: 0               // ランキング外のrowの上の隙間
</style>
