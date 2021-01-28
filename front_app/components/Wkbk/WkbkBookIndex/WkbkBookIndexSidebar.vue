<template lang="pug">
b-sidebar.WkbkBookIndexSidebar.is-unselectable(fullheight right overlay v-model="base.sidebar_p")
  .mx-4.my-4
    .is-flex.is-justify-content-start.is-align-items-center
      b-button(@click="base.sidebar_toggle" icon-left="menu")
    .mt-4
      b-menu
        b-menu-list(label="Action")
          //- b-menu-item(tag="nuxt-link" :to="{name: 'library-books-new'}" label="問題集作成" @click.native="sound_play('click')")
          b-menu-item(tag="nuxt-link" :to="{name: 'library-articles'}" label="問題リスト" @click.native="sound_play('click')")
        b-menu-list(label="表示オプション")
          b-menu-item.sidebar_columns_toggle(@click="sound_play('click')")
            template(slot="label" slot-scope="props")
              | 表示カラム
              b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
            template(v-for="e in base.BookIndexColumnInfo.values")
              b-menu-item(
                v-if="e.togglable"
                @click.stop="base.cb_toggle_handle(e)"
                :class="{is_visible_off: !base.visible_hash[e.key], is_visible_on: base.visible_hash[e.key]}"
                :key="e.key"
                :label="e.name"
                )
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookIndexSidebar",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkBookIndexSidebar
  .dropdown-menu
    min-width: 0
    a:focus
      outline: none
  .menu-label:not(:first-child)
    margin-top: 2em

</style>
