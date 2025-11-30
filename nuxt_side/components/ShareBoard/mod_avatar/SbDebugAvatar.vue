<template lang="pug">
.SbDebugAvatar.column.is-12
  .columns.is-multiline
    .column.is-4
      .panel
        .panel-heading
          | アバター
        a.panel-block(@click="SB.avatar_input_modal_open_handle") 入力モーダル起動
        a.panel-block(href="?room_key=dev_room&user_name=a&FIXED_MEMBER=a,b,c,d,e&FIXED_ORDER=a,b,c,d,e&autoexec=avatar_input_modal_open_handle") 他者がいると仮定して起動する
        a.panel-block(href="?room_key=dev_room&user_name=a&autoexec=order_self_only_auto_setup,avatar_input_modal_open_handle") 自分だけを順番設定に入れた状態で起動する (すぐに切り替わるのを確認できる)
        a.panel-block(@click="SB.user_selected_avatar_clear") 空にする (履歴はそのまま)
        a.panel-block(@click="SB.avatar_history_init") 履歴を空にする
    .column.is-4
      .panel.assert_var
        .panel-heading
          | [assert_var]
        .panel-block user_selected_avatar:{{SB.user_selected_avatar}}
        .panel-block avatar_history:{{SB.avatar_history_ary.join("")}}
        .panel-block all_user_selected_avatars:{{SB.all_user_selected_avatars}}
</template>

<script>
import _ from "lodash"
import { support_child } from "../support_child.js"

export default {
  name: "SbDebugAvatar",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbDebugAvatar
  __css_keep__: 0
</style>
