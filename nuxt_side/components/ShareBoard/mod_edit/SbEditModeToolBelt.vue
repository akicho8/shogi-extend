<template lang="pug">
.SbEditModeToolBelt.footer_buttons(v-if="SB.edit_mode_p")
  .buttons.mb-0.is-centered.are-small.is-marginless.mt-3
    b-button(@click="SB.king_formation_auto_set$(true)") 詰将棋検討用玉配置
    b-button(@click="SB.king_formation_auto_set$(false)") 玉回収

  .buttons.mb-0.is-centered.are-small.is-marginless.mt-3(v-if="SB.edit_mode_kifu_vo")
    PiyoShogiButton(:href="SB.edit_mode_kifu_vo.piyo_url")
    KentoButton(tag="a" :href="SB.edit_mode_kifu_vo.kento_url" target="_blank")
    KifCopyButton(@click="SB.edit_mode_kifu_copy_handle") コピー

  .buttons.mb-0.is-centered.are-small.is-marginless.mt-3
    b-button(@click="SB.kifu_read_modal_open_handle()") 棋譜の読み込み

  .buttons.is-centered.mt-4(v-if="development_p && false")
    b-button.has-text-weight-bold(
      v-if="SB.tweet_button_show_p"
      :type="SB.tweet_button_type"
      icon-left="twitter"
      @click="SB.tweet_modal_handle"
      )
      | ツイート
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"

.SbEditModeToolBelt
  .button
    margin-bottom: 0
</style>
