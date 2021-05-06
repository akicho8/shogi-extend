<template lang="pug">
.modal-card.ForceSyncModal
  ////////////////////////////////////////////////////////////////////////////////
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-6.has-text-weight-bold
      | 自分の盤を全員に反映

  ////////////////////////////////////////////////////////////////////////////////
  section.modal-card-body
    p
      | 操作ミスによる対局反故などを防ぐために盤の同期はシンプルに<b>新しい手を指したときだけ</b>としていますが、
      | これを使うと例外的に自分({{base.user_name}})の盤の状態をそのまま全員の盤に反映(上書きコピー)します
    p
      | よくありそうな使い道は<b>反則の取り消し</b>と<b>待った</b>です。
      | 本来は反則をした人が(合意の上で)小さい左矢印で1手戻して正しい手を指すだけでよいのですが、
      | 当人が慣れていない場合は慣れている人が1手戻した局面を反映してあげてメッセージで当人に指し直しを促せばよいです
    p
      | 同様に<b>続けて初手から対局する</b>場合も初手を指す人が左矢印で初手に戻してから指せばよいのですが、いったん全員の盤が初期配置になっていないと不安でしょうから、慣れている人が戻した初期配置を全員に配ってから始めるとよいです
    p
      | その他には対局後に<b>検討したい局面</b>に合わせたり、慣れた人がカスタマイズした配置(例えば駒落ち)の初期配置を配るときにも使えます

  footer.modal-card-foot
    b-button.close_button(@click="close_handle" icon-left="chevron-left") やめとく
    b-button.test_button(@click="test_handle" v-if="development_p") テスト
    b-button.sync_button(@click="sync_handle" type="is-danger") 本当に反映する
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
    width: 50ch
  .modal-card-body
    padding: 1.5rem
    p:not(:first-child)
      margin-top: 0.75rem
  .modal-card-foot
    justify-content: space-between
    .button
      min-width: 6rem
      font-weight: bold
</style>
