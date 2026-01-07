<template lang="pug">
.SbDebugResign.column.is-12
  .columns.is-multiline
    .column.is-4
      .panel
        .panel-heading
          | 投了
        a.panel-block(href="?self_vs_self_enable_p=false&room_restore_feature_p=false&room_key=dev_room&user_name=a&FIXED_MEMBER=a,b&FIXED_ORDER=a,b&room_after_create=cc_auto_start_10m,resign_confirm_modal_open_handle") 投了モーダルを開く (URL固定)
        a.panel-block(@click="SB.resign_confirm_modal_open_handle") 投了モーダルを開く
        a.panel-block(@click="SB.resign_call()") 投了ボタン(バリデーションあり)
        a.panel-block(@click="SB.resign_call({win_location_key: 'black'})") ☗側の投了実処理
        a.panel-block(@click="SB.resign_call({win_location_key: 'white'})") ☖側の投了実処理
        a.panel-block(@click="SB.battle_save_by_win_location('black')") ☗側を勝ちとする (DB → 全員)
        a.panel-block(@click="SB.battle_save_by_win_location('white')") ☖勝を勝ちとする (DB → 全員)
        a.panel-block(@click="SB.draw_call") 引き分け
        a.panel-block(@click="SB.ending_modal_open({win_location_key: 'black', checkmate: true})") 結末モーダル ☗勝ち (詰み)
        a.panel-block(@click="SB.ending_modal_open({win_location_key: 'white'})") 結末モーダル ☖勝ち (投了)
        a.panel-block(@click="SB.ending_modal_open({win_location_key: null})") 結末モーダル 引き分け
    .column.is-4
      .panel.assert_var
        .panel-heading
          | [assert_var]
        //- .panel-block {{SB.__battle_memberships("black")}}
        //- .panel-block {{SB.__battle_memberships("white")}}
</template>

<script>
import _ from "lodash"
import { support_child } from "../support_child.js"

export default {
  name: "SbDebugResign",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbDebugResign
  __css_keep__: 0
</style>
