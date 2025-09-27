<template lang="pug">
.SwarsCustomSearchApp
  DebugBox(v-if="development_p")
    p battled_at_range: {{$gs.short_inspect(battled_at_range)}}
    p user_key: {{$gs.short_inspect(user_key)}}
    p vs_user_keys: {{$gs.short_inspect(vs_user_keys)}}

  SwarsCustomSearchSidebar()

  MainNavbar(wrapper-class="container is-fluid")
    template(slot="brand")
      b-navbar-item(@click="back_click_handle")
        b-icon(icon="chevron-left")
      b-navbar-item.has-text-weight-bold(@click="title_click_handle") カスタム検索
    template(slot="end")
      //- NavbarItemLogin
      //- NavbarItemProfileLink
      template(v-if="development_p")
        b-navbar-item.has-text-weight-bold(@click="filter_modal_handle") モーダル版
      NavbarItemSidebarOpen(@click="sidebar_toggle")

  MainSection
    .container.is-fluid
      .columns.form_block.is-variable.is-0
        .column.is-12
          SwarsCustomSearchFormAll
      SwarsCustomSearchDebugPanels(v-if="development_p")
</template>

<script>
import { support_parent    } from "./support_parent.js"
import { mod_chore         } from "./mod_chore.js"
import { mod_query_builder } from "./mod_query_builder.js"
import { mod_filter_modal         } from "./mod_filter_modal.js"
import { mod_support       } from "./mod_support.js"
import { mod_form          } from "./mod_form.js"
import { mod_storage       } from "./mod_storage.js"
import { mod_sidebar       } from "./mod_sidebar.js"

export default {
  name: "SwarsCustomSearchApp",
  mixins: [
    support_parent,
    mod_form,
    mod_chore,
    mod_query_builder,
    mod_filter_modal,
    mod_support,
    mod_storage,
    mod_sidebar,
  ],
  props: {
    xi: { type: Object,  required: true, },
  },
  provide() {
    return {
      TheApp: this,
    }
  },
  methods: {
    search_click_handle() {
      this.sfx_play_click()
      this.app_log({emoji: ":絞込:", subject: "カスタム検索", body: this.new_query})
      this.$router.push({name: "swars-search", query: {query: this.new_query}})
    },
  },
}
</script>

<style lang="sass">
@import "./support.sass"
.SwarsCustomSearchApp
  +bulma_columns_vertical_minus_margin_clear

  .MainSection.section
    +mobile
      padding: 0rem 0.75rem 0.25rem // 入力フィールドが 0.5 なので 0.25 足して左右の余白と一致する (下の部分)
    +tablet
      padding: 1.0rem 0rem

  .container
    +mobile
      padding: 0
</style>
