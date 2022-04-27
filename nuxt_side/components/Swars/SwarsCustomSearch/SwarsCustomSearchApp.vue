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
      b-navbar-item.has-text-weight-bold カスタム検索
    //- template(slot="end")
    //-   NavbarItemLogin
    //-   NavbarItemProfileLink
    //-   //- NavbarItemSidebarOpen(@click="sidebar_toggle")

  MainSection
    .container.is-fluid
      .columns.form_block
        .column
          b-field.field_block.new_query_field(label="")
            //- p.control
            //-   span.button.is-static.is-fullwidth
            //-     | {{new_query}}
            b-input(v-model.trim="new_query" disabled expanded size="is-medium")
            p.control
              b-button(@click="search_click_handle" type="is-primary" size="is-medium")
                | 検索

          b-field.field_block(label="ウォーズID")
            b-input(v-model.trim="user_key" required placeholder="itoshinTV")

          SimpleRadioButtons.field_block(:base="base" model_name="ChoiceXmodeInfo" var_name="xmode_key")

          b-field.field_block(label="手数")
            b-switch(v-model="turn_max_enabled")
            b-numberinput(controls-position="compact" expanded v-model="turn_max" :min="0" :exponential="true" @click.native="sound_play_click()")
            b-select(v-model="turn_max_op" @input="sound_play_click()")
              option(v-for="e in OpInfo.values" :value="e.key") {{e.name}}

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

import { ChoiceXmodeInfo } from "./models/choice_xmode_info.js"
import { OpInfo   } from "./models/op_info.js"

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
    search_click_handle() {
      this.sound_play_click()
      this.$router.push({name: "swars-search", query: {query: this.new_query}})
    },
    back_handle() {
      this.sound_play_click()
      this.back_to({name: "swars-search", query: {query: this.user_key}})
    },
  },

  computed: {
    base() { return this },

    ChoiceXmodeInfo()   { return ChoiceXmodeInfo                       },
    choice_xmode_info() { return ChoiceXmodeInfo.fetch(this.xmode_key) },

    OpInfo()            { return OpInfo                                },
    turn_max_op_info()  { return OpInfo.fetch(this.turn_max_op)        },

    new_query() {
      let av = []

      av.push(this.user_key)
      av.push(this.choice_xmode_info.to_query_part)

      if (this.turn_max_enabled) {
        av.push(`手数:${this.turn_max_op_info.value}${this.turn_max}`)
      }

      let str = av.join(" ")
      str = this.str_squish(str)
      return str
    },
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

  .new_query_field
    &:hover
      background-color: unset

.STAGE-development
  .SwarsCustomSearchApp
    .column
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
