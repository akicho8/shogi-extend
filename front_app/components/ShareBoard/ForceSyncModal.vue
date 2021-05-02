<template lang="pug">
.modal-card.ForceSyncModal
  ////////////////////////////////////////////////////////////////////////////////
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-6.has-text-weight-bold
      | 自分の盤の配置を全員の盤に反映

  ////////////////////////////////////////////////////////////////////////////////
  section.modal-card-body
    p
      | 反映するのは基本的には<b>新しい手を指したときだけ</b>ですが、
      | これを使うと{{base.user_name}}さんの現在の盤の状態をそのまま全員の盤に反映します
    p
      | 二歩や王手放置の取り消しはそれをしてしまった人が(合意の上で)小さい矢印で1手戻して指し直すだけで続行できるのですが、当人が成れていなくて動揺している場合は他者が1手戻した局面を全員に反映してあげてメッセージで当人に指し直しを促せばよいでしょう
      |
    p
      | また対局後に検討したい局面に合わせたり、再対局のために盤を初期配置に戻したり、カスタマイズした配置(例えば駒落ち)の初期配置にセットしたりするときにも使えます

  footer.modal-card-foot
    b-button.close_button(@click="close_handle" icon-left="chevron-left") 閉じる
    b-button.test_button(@click="test_handle" v-if="development_p") テスト
    b-button.send_button(@click="sync_handle" type="is-primary") 反映する
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "ForceSyncModal",
  mixins: [
    support_child,
  ],
  methods: {
    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
    test_handle() {
      this.sound_play("click")
      this.base.force_sync()
    },
    sync_handle() {
      this.sound_play("click")
      this.base.force_sync()
      this.$emit("close")
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.ForceSyncModal
  +tablet
    width: 48ch
  .modal-card-body
    padding: 1.0rem
    p:not(:first-child)
      margin-top: 0.75rem
  .modal-card-foot
    justify-content: space-between
    .button
      min-width: 6rem
      font-weight: bold
</style>
