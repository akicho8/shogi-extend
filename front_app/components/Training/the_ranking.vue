<template lang="pug">
.the_ranking
  the_footer
  .primary_header
    .header_center_title {{current_title}}

    b-dropdown(position="is-bottom-left")
      b-icon.header_item.with_icon.rjust(slot="trigger" icon="dots-vertical" @click.native="dots_vertical_click_handle")
      template(v-for="season in seasons")
        b-dropdown-item(@click="switch_to(season)") {{season.name}}

  .secondary_header
    b-tabs.tabs_in_secondary(v-model="tab_index" expanded @input="tab_change_handle")
      template(v-for="tab_info in TabInfo.values")
        b-tab-item.is-size-2(:label="tab_info.name")

  .the_ranking_rows(v-if="rank_data")
    the_ranking_row(v-for="row in rank_data.rank_records" :row="row")

    template(v-if="!rank_data.user_rank_in && rank_data.current_user_rank_record")
      the_ranking_row.current_user_rank_record(:row="rank_data.current_user_rank_record")
</template>

<script>
import MemoryRecord from 'js-memory-record'

class TabInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "rating",             name: "総合",         unit: null,     },
      { key: "straight_win_count", name: "連勝中",       unit: "連勝中", },
      { key: "straight_win_max",   name: "最多連勝数",   unit: "連勝",   },
    ]
  }

  get handle_method_name() {
    return `${this.key}_handle`
  }
}

import { support } from "./support.js"
import the_ranking_row from "./the_ranking_row.vue"
import the_footer from "./the_footer.vue"

export default {
  name: "the_ranking",
  mixins: [
    support,
  ],
  components: {
    the_ranking_row,
    the_footer,
  },
  props: {
  },
  data() {
    return {
      tab_index: null,
      rank_data: null,
      seasons: null,
      season_id: null,
    }
  },

  created() {
    this.app.lobby_unsubscribe()

    this.seasons_fetch()

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

    straight_win_count_handle() {
      this.mode_select("straight_win_count")
    },

    straight_win_max_handle() {
      this.mode_select("straight_win_max")
    },

    ////////////////////////////////////////////////////////////////////////////////

    mode_select(tab_key) {
      const tab_info = TabInfo.fetch(tab_key)
      this.tab_index = tab_info.code
      // this.$gtag.event("open", {event_category: "ランキング", event_label: tab_info.name})
    },

    tab_change_handle() {
      this.sound_play("click")
      this[this.current_tab_info.handle_method_name]()
      this.fetch_handle()
    },

    ////////////////////////////////////////////////////////////////////////////////

    fetch_handle() {
      // if (this.rank_records_hash[this.current_tab_info.key]) {
      // } else {
      const params = {
        ranking_key: this.current_tab_info.key,
        season_id:   this.season_id,
      }
      if (this.development_p) {
        params.take = 5
        params.shuffle = true
      }
      this.rank_data = null
      this.api_get("ranking_fetch", params, e => {
        this.rank_data = e.rank_data
      })
    },

    // 音を出すためだけのフック
    dots_vertical_click_handle() {
      this.sound_play('click')
      // if (!this.seasons) {
      //   this.seasons_fetch()
      // }
    },

    seasons_fetch() {
      this.api_get("seasons_fetch", {}, e => {
        if (e.seasons) {
          this.seasons = e.seasons
        }
      })
    },

    switch_to(season) {
      this.sound_play("click")
      this.season_id = season.id
      this.fetch_handle()
    },
  },

  computed: {
    TabInfo() { return TabInfo },

    current_tab_info() {
      return TabInfo.fetch(this.tab_index)
    },

    current_season() {
      if (this.seasons) {
        if (this.season_id) {
          return this.seasons.find(e => e.id === this.season_id)
        } else {
          return this.seasons[0]
        }
      }
    },

    current_title() {
      if (this.current_season) {
        return this.current_season.name
      }
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
  margin-bottom: $margin_bottom

  .current_user_rank_record
    margin-top: 0               // ランキング外のrowの上の隙間
</style>
