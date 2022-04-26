<template lang="pug">
.SwarsCustomSearchApp
  b-loading(:active="$fetchState.pending")

  DebugBox(v-if="development_p")
    //- p mounted_then_query_present_p: {{mounted_then_query_present_p}}

  //- SwarsCustomSearchSidebar(:base="base")

  MainNavbar(wrapper-class="container is-fluid")
    template(slot="brand")
      b-navbar-item(@click="base.back_handle")
        b-icon(icon="chevron-left")
        //- b-navbar-item(tag="nuxt-link" :to="{}" @click.native="reset_handle")
      b-navbar-item.has-text-weight-bold 詳細検索
    //- template(slot="end")
    //-   NavbarItemLogin
    //-   NavbarItemProfileLink
    //-   //- NavbarItemSidebarOpen(@click="sidebar_toggle")

  MainSection
    .container.is-fluid
      .columns
        .column
          SimpleRadioButtons.field_block(:base="base" model_name="ChoiceLoopInfo" var_name="loop_key")

          //- b-field
          //-   b-autocomplete#query(

          //- b-field
          //-   b-autocomplete#query(
          //-     max-height="50vh"
          //-     size="is-medium"
          //-     v-model.trim="query"
          //-     :data="search_input_complement_list"
          //-     type="search"
          //-     placeholder="ウォーズIDを入力"
          //-     open-on-focus
          //-     clearable
          //-     expanded
          //-     @select="search_select_handle"
          //-     @keydown.native.enter="search_enter_handle"
          //-     ref="main_search_form"
          //-     )
          //-   p.control
          //-     b-button.search_click_handle(@click="search_click_handle" icon-left="magnify" size="is-medium")

          //- SwarsCustomSearchBoard(:base="base" v-if="layout_info.key === 'is_layout_board'")
          //- SwarsCustomSearchTable(:base="base" v-if="layout_info.key === 'is_layout_table'")
      SwarsCustomSearchDebugPanels(:base="base" v-if="development_p")
</template>

<script>
import _ from "lodash"

import { support_parent  } from "./support_parent.js"
import { app_chore       } from "./app_chore.js"
import { app_search      } from "./app_search.js"
import { app_storage     } from "./app_storage.js"

import { ChoiceLoopInfo            } from "./models/choice_loop_info.js"

import { ParamInfo   } from "./models/param_info.js"

export default {
  name: "SwarsCustomSearchApp",
  mixins: [
    support_parent,
    app_search,
    app_chore,
    app_storage,
  ],

  data() {
    return {
      xi: {},
    }
  },

  fetchOnServer: false,
  fetch() {
    this.ga_click("詳細検索")

    let params = {
      ...this.$route.query,
    }

    params = this.pc_url_params_clean(params)

    return this.$axios.$get("/api/swars/custom_search_setup.json", {params}).then(xi => {
      this.xi = xi
    })
  },

  methods: {
    back_handle() {
      this.sound_play_click()
      this.back_to({name: "swars-search", query: {query: this.$route.query.uesr_key}})
    },
  },

  computed: {
    base() { return this },
    ChoiceLoopInfo()  { return ChoiceLoopInfo                      },
    choice_loop_info() { return ChoiceLoopInfo.fetch(this.loop_key) },
  },
}
</script>

<style lang="sass">
.SwarsCustomSearchApp
  .MainSection.section
    +tablet
      padding: 1.75rem 0rem

  .container
    +mobile
      padding: 0

  .b-table
    margin-top: 0rem
    // margin-bottom: 2rem
    +mobile
      margin-top: 1rem
    td
      vertical-align: middle

    .is-xmode-通常
      // background-color: $success-light
      // background-color: $white-ter
      // background-color: $primary-light
    .is-xmode-友達
      // background-color: $primary-light
      // background-color: $primary-light
      background-color: $white-ter
    .is-xmode-指導
      background-color: $primary-light

  // 小さな盤面をたくさん表示
  .CustomShogiPlayer
    --sp_piece_count_font_size: 8px
    --sp_stand_piece_w: 20px
    --sp_stand_piece_h: 25px
    --sp_piece_count_gap_bottom: 64%

.STAGE-development
  .SwarsCustomSearchApp
    .column
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
