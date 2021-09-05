<template lang="pug">
.ActbMenuEtc
  .primary_header
    .header_center_title その他
  .menu_buttons
    b-button(expanded @click="base.menu_to('ActbMenuDebug')" type="is-danger" v-if="permit_staff_p") デバッグモード
    b-button(expanded tag="nuxt-link" :to="{name: 'index'}" @click.native="sound_play('click')") TOP
    b-button(expanded @click="base.menu_to('ActbMenuRoot')") もどる
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "ActbMenuEtc",
  mixins: [
    support_child,
  ],
}
</script>

<style lang="sass">
@import "../support.sass"
.ActbMenuEtc
</style>
