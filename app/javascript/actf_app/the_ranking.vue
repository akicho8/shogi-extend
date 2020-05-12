<template lang="pug">
.the_ranking
  .columns.is-centered
    .column
        b-tabs.main_tabs(v-model="tab_index" expanded @change="tab_change_handle")
          template(v-for="tab_info in TabInfo.values")
            b-tab-item(:label="tab_info.name")
              template(v-for="(row, i) in rank_records_hash[tab_info.key]")
                .row.is-flex(:class="{active: row.id === app.current_user.id}")
                  .rank_block
                    .rank.is-size-5.has-text-weight-bold.has-text-right.has-text-primary
                      | {{i + 1}}
                  figure.image.is-48x48
                    img.is-rounded(:src="row.avatar_path")
                  .name_with_rating
                    .name.has-text-weight-bold
                      | {{row.name}}
                    .rating
                      | {{row[tab_info.key]}}
                      span.unit(v-if="tab_info.unit")
                        | {{tab_info.unit}}
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

import the_support from "./the_support.js"

export default {
  name: "the_ranking",
  mixins: [
    the_support,
  ],
  components: {
  },
  props: {
  },
  data() {
    return {
      tab_index: null,
      rank_records_hash: {},
    }
  },

  created() {
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
      if (this.rank_records_hash[this.current_tab_info.key]) {
      } else {
        this.http_get_command(this.app.info.put_path, { ranking_fetch: true, ranking_key: this.current_tab_info.key }, e => {
          if (e.rank_records) {
            this.$set(this.rank_records_hash, e.ranking_key, e.rank_records)
          }
        })
      }
    },
  },

  computed: {
    TabInfo() { return TabInfo },

    current_tab_info() {
      return TabInfo.fetch(this.tab_index)
    },

  },
}
</script>

<style lang="sass">
@import "../stylesheets/bulma_init.scss"
.the_ranking
  // position: relative
  // .delete
  //   position: absolute
  //   top: 0rem
  //   right: 0rem
  //   z-index: 1

  .main_tabs
    .tab-content
      padding: 0
      padding-top: 0

  .row
    padding-top: 1rem
    padding-bottom: 0.7rem

    &.active
      background-color: $white-ter

    &:not(:first-child)
      border-top: 1px solid $grey-lighter

    justify-content: flex-start
    align-items: center

    .rank_block
      min-width: 3rem
    .image
      margin-left: 1rem
      img
        height: 48px

    .name_with_rating
      margin-left: 1rem
      .name
      .rating
        .unit
          margin-left: 0.2rem
</style>
