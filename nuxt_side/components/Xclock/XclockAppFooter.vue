<template lang="pug">
.XclockAppFooter.is-flex
  nuxt-link.item(:to="{name: 'index'}" @click.native="sfx_play_click()")
    b-icon(icon="home")

  b-dropdown.cc_preset_dropdown(position="is-top-left" @active-change="e => base.dropdown_active_change(e)" ref="preset_menu_pull_down")
    .item(slot="trigger")
      b-icon(icon="menu")

    template(v-for="e in base.CcRuleInfo.values")
      b-dropdown-item(@click="base.rule_set(e.cc_params_one)") {{e.name}}

    template(v-if="development_p")
      b-dropdown-item(:separator="true")
      b-dropdown-item(@click="base.rule_set({initial_main_min: 60*2, initial_read_sec:0,  initial_extra_min: 0,  every_plus: 0})") 1行 7文字
      b-dropdown-item(@click="base.rule_set({initial_main_min: 30,   initial_read_sec:0,  initial_extra_min: 0,  every_plus: 0})") 1行 5文字
      b-dropdown-item(@click="base.rule_set({initial_main_min: 60*2, initial_read_sec:0,  initial_extra_min: 1,  every_plus: 0})") 2行 7文字
      b-dropdown-item(@click="base.rule_set({initial_main_min: 60*2, initial_read_sec:60, initial_extra_min: 1,  every_plus:60})") 3行 7文字

  .item(@click="base.play_handle")
    b-icon(icon="play")

  .item(@click="base.copy_handle")
    b-icon(icon="content-duplicate")

  .item(@click="base.keyboard_handle")
    b-icon(icon="keyboard")
</template>

<script>
import { support } from "./support.js"

export default {
  name: "XclockAppFooter",
  props: {
    base: { type: Object, required: true },
  },
  mixins: [
    support,
  ],
}
</script>

<style lang="sass">
@import "support.sass"
.XclockAppFooter
  z-index: 1

  @media (orientation: landscape)
    height: 48px
  @media (orientation: portrait)
    height: 64px
  +desktop
    height: 64px

  width: 100%

  padding: 0 8px

  justify-content: space-between
  align-items: center

  .dropdown, .dropdown-trigger
    height: 100%

  +desktop
    justify-content: center
    .button, .item
      margin-left: 5rem
      margin-right: 5rem

  border-top: 1px solid $grey-lighter
  background-color: change_color($white-ter, $alpha: 0.96)

  .item
    color: inherit
    cursor: pointer

    padding-right: 1rem
    padding-left: 1rem
    height: inherit

    display: flex
    justify-content: center
    align-items: center
</style>
