<template lang="pug">
.GalleryTopApp
  client-only
    DebugBox(v-if="development_p")
      p column_size_code: {{column_size_code}}
    MainNavbar(:spaced="false" wrapper-class="container is-fluid px-0")
      template(slot="brand")
        NavbarItemHome
        b-navbar-item.has-text-weight-bold.px_0_if_mobile(@click.native="title_click_handle")
          | 木目盤テクスチャ集
      template(slot="end")
        b-navbar-item.slider_container.is-hidden-mobile(tag="div")
          b-slider(:min="0" :max="ColumnSizeInfo.values.length - 1" :tooltip="false" rounded v-model="column_size_code" type="is-light" size="is-small" @input="slider_change_handle")
            template(v-for="e in ColumnSizeInfo.values")
              b-slider-tick(:value="e.code")

    MainSection.when_mobile_footer_scroll_problem_workaround
      .container.is-fluid
        .columns.is-multiline.is-variable.is-0-mobile.is-3-tablet.is-3-desktop.is-3-widescreen.is-3-fullhd
          .column.is-12
            //- https://buefy.org/documentation/pagination
            b-pagination(:total="total" :per-page="per" :current.sync="page" @change="page_change_handle" order="default" simple)
          template(v-for="(_, i) in page_items")
            .column.is_texture(:class="column_size_info.column_class" v-if="column_size_code !== null")
              a.image.is-block(:href="filename_for(i)" target="_blank" @click="sound_play('click')")
                img(:src="filename_for(i)")
                .image_number
                  .image_number_body
                    | {{display_number_for(i)}}
          .column.is-12.cc_container.is-flex.is-justify-content-center
            a.image.is-block(href="https://creativecommons.org/licenses/by-sa/4.0/deed.ja" target="_blank" @click="sound_play('click')")
              img(src="by-sa.svg")

    //- DebugBox(v-if="development_p")
    //-   p query: {{query}}
    //-   p tag: {{tag}}
    //-   //- p search_p: {{search_p}}
    //-
    //- FetchStateErrorMessage(:fetchState="$fetchState")
    //-
    //- GalleryTopSidebar(:base="base")
    //- GalleryTopNavbar(:base="base")
    //- //- (v-if="!$fetchState.pending && !$fetchState.error")
    //- MainSection.when_mobile_footer_scroll_problem_workaround
    //-   .container.is-fluid
    //-     GalleryTopContent(:base="base")
    //-
    GalleryTopDebugPanels(:base="base" v-if="development_p")
</template>

<script>
const TOTAL_ITEMS = 720

import { ColumnSizeInfo } from "../models/column_size_info.js"
// import { Banana      } from "../models/banana.js"
// import { XpageInfo } from "../models/xpage_info.js"
//
import { support_parent } from "./support_parent.js"
// import { app_table      } from "./app_table.js"
// import { app_tabs       } from "./app_tabs.js"
import { app_storage    } from "./app_storage.js"
// import { app_sidebar    } from "./app_sidebar.js"
// import { app_search     } from "./app_search.js"
//
// import _ from "lodash"
import { ParamInfo } from "./models/param_info.js"

const ModExtsprintf = require('extsprintf')
import { simple_patination_methods } from "@/components/simple_patination_methods.js"

export default {
  name: "GalleryTopApp",
  mixins: [
    support_parent,
    simple_patination_methods,
    // app_table,
    // app_tabs,
    app_storage,
    // app_sidebar,
    // app_search,
  ],
  data() {
    return {
      column_size_code: null,
    }
  },
  created() {
    this.total = TOTAL_ITEMS
  },
  methods: {
    display_number_for(i) {
      return this.offset + i + 1
    },
    filename_for(i) {
      return this.sprintf(`${this.$config.MATERIAL_DIR_PREFIX}/material/board/%04d.png`, this.offset + i + 1)
    },
    title_click_handle() {
      this.sound_play("click")
      this.page = 1
    },
    slider_change_handle(code) {
      this.sound_play("click")
    },
  },
  computed: {
    base() { return this },
    meta() {
      return {
        title: "木目盤テクスチャ集",
        description: "将棋盤用に特化した木目盤のテクスチャ集です",
        og_image_key: "gallery",
      }
    },
    default_per() { return 100 },
    ColumnSizeInfo() { return ColumnSizeInfo },
    column_size_info() { return ColumnSizeInfo.fetch(this.column_size_code) },
    ParamInfo() { return ParamInfo },
  },
  //
  // data() {
  //   return {
  //     meta: null,
  //   }
  // },
  //
  // watch: {
  //   "$route.query": "$fetch",
  // },
  //
  // mounted() {
  //   this.ga_click("動画一覧")
  // },
  //
  // fetchOnServer: false,
  // fetch() {
  //   // this.__assert__(this.search_preset_key, "this.search_preset_key")
  //   this.query       = this.$route.query.query
  //   // this.search_preset_key = this.$route.query.search_preset_key ?? this.search_preset_key ?? "everyone" // 引数 -> localStorageの値 -> 初期値 の順で決定
  //   this.search_preset_key = this.$route.query.search_preset_key
  //   this.page        = this.$route.query.page
  //   this.per         = this.$route.query.per
  //   // this.sort_column = this.$route.query.sort_column ?? "updated_at"
  //   // this.sort_order  = this.$route.query.sort_order ?? "desc"
  //   this.tag         = this.$route.query.tag
  //
  //   // this.url_params とは異なり最終的な初期値を設定する
  //   const params = {
  //     query:       this.query,
  //     search_preset_key:       this.search_preset_key,
  //     page:        this.page,
  //     per:         this.per,
  //     // sort_column: this.sort_column,
  //     // sort_order:  this.sort_order,
  //     tag:         this.tag,
  //   }
  //   return this.$axios.$get("/api/gallery/tops/index.json", {params}).then(e => {
  //     this.meta = e.meta
  //     if (this.query || this.tag) {
  //       this.meta.title = _.compact([this.query, ...this.tags]).join(" ") + ` - ${this.meta.title}`
  //     }
  //     // this.tab_index   = this.IndexScopeInfo.fetch(this.search_preset_key).code
  //     this.bananas = e.bananas.map(e => new Banana(this, e))
  //     this.xpage_info = new XpageInfo(e.xpage_info)
  //     // this.total       = e.total
  //     // this.banana_counts = e.banana_counts
  //   })
  // },
  //
  // methods: {
  //   router_push(params) {
  //     params = {...this.url_params, ...params}
  //     params = this.hash_compact_if_blank(params)
  //     this.$router.push({name: "video", query: params})
  //   },
  // },
  //
  // computed: {
  // },
}
</script>

<style lang="sass">
// @import "../all_support.sass"
// .STAGE-development
//   .columns
//     border: 1px dashed change_color($danger, $alpha: 0.5)
//     .column
//       border: 1px dashed change_color($primary, $alpha: 0.5)
//
// .GalleryTopApp
//   .MainSection.section
//     +mobile
//       padding: 0.75rem
//     +tablet
//       padding: 1.5rem

.GalleryTopApp
  .slider_container
    width: 10rem

  .MainSection.section
    +mobile
      padding: 0.75rem
      .columns
        margin: 0
      .column
        padding: 0
        &:not(:first-child)
          margin-top: 0.75rem
    +tablet
      padding: 1.5rem

  .is_texture
    img
      border-radius: 3px

  .image_number
    position: absolute
    top: 0
    left: 0
    .image_number_body
      line-height: 1.0
      padding: 0.25rem 0.25rem
      font-size: $size-7
      border-radius: 3px
      color: change_color($warning, $lightness: 30%)
      background-color: change_color($warning, $lightness: 100%)
      opacity: 0.1

  .cc_container
    .image
      width: 100%
      +tablet
        max-width: 12rem

.STAGE-development
  .GalleryTopApp
    .column
      border: 1px dashed change_color($success, $alpha: 0.5)
    .image
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .img
      border: 1px dashed change_color($danger, $alpha: 0.5)
    .image_number
      border: 1px dashed change_color($warning, $alpha: 0.5)

</style>
