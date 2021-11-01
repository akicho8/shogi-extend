<template lang="pug">
b-sidebar.is-unselectable.StopwatchSidebar(fullheight right overlay v-model="base.sidebar_p")
  .mx-4.my-4
    .is-flex.is-justify-content-start.is-align-items-center
      b-button.px-5(@click="base.sidebar_toggle" icon-left="menu")
    .mt-4
      b-menu
        b-menu-list(label="Action")
          b-menu-item.is_active_unset(label="最後のタイムだけリセット (r)"   @click="base.rap_reset"     :disabled="base.lap_counter === 0")
          b-menu-item.is_active_unset(label="1つ前に戻す (z)"                @click="base.revert_handle" :disabled="base.rows.length === 0")
          b-menu-item.is_active_unset(label="最後の解答の正誤を反転する (t)" @click="base.toggle_handle" :disabled="base.rows.length === 0")

        b-menu-list(label="再テスト")
          b-menu-item.is_active_unset(label="不正解のみ"         @click="base.reset_by_x"                :disabled="base.rows.length === 0 || base.mode === 'playing'")
          b-menu-item.is_active_unset(label="不正解と指定秒以上" @click="base.reset_by_x_with_n_seconds" :disabled="base.rows.length === 0 || base.mode === 'playing'")

        b-menu-list(label="その他")
          b-menu-item.is_active_unset(label="履歴"               @click="base.history_modal_show"   :disabled="base.mode !== 'standby'")
          b-menu-item.is_active_unset(label="パーマリンク"       @click="base.parmalink_modal_show" :disabled="base.mode !== 'standby'")
          b-menu-item.is_active_unset(label="キーボード操作"     @click="base.keyboard_modal_show"                                )
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "StopwatchSidebar",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "./support.sass"

.StopwatchSidebar
  .sidebar-content
    width: 20rem

  .menu-label
    margin-top: 2em
</style>
