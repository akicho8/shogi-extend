<template lang="pug">
.modal-card.ForceSyncModal
  ////////////////////////////////////////////////////////////////////////////////
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-5.has-text-weight-bold
      | 局面同期

  ////////////////////////////////////////////////////////////////////////////////
  section.modal-card-body
    p
      | 操作ミスによる事故を防ぐため、盤の同期は単に<b>新しい手を指したときだけ</b>としています。
      | が、これを使うと例外的に自分の盤の状態をそのまま他の人の盤に転送します。
    p
      | よくありそうな使い道は<b>反則の取り消し</b>と<b>待った</b>です。
      | 本来は反則をした人が合意の上、小さい左矢印で1手戻して正しい手を指すだけでよいのですが、
      | 当人が慣れていない場合は慣れている人が1手戻した局面を転送してメッセージで当人に正しい手を指すよう促せばよいです
    p
      | 同様に<b>初期配置に戻して再度対局する</b>場合も初手を指す人が左矢印で初期配置に戻してから指せばよいのですが、わからない場合は慣れている人が初期配置に戻した盤を全員に配ってから始めるとよいです
    p
      | その他には対局後に<b>検討したい局面</b>に合わせたり、カスタマイズした駒落ち等の初期配置を配るときにも使えます

  footer.modal-card-foot
    b-button.close_button(@click="close_handle" icon-left="chevron-left") やめとく
    b-button.test_button(@click="test_handle" v-if="development_p") テスト
    b-button.sync_button(@click="sync_handle" type="is-danger") 本当に転送する
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
      this.base.force_sync("テスト転送")
    },
    sync_handle() {
      this.sound_play("click")
      this.base.force_sync_direct()
      this.$emit("close")
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.ForceSyncModal
  +tablet
    width: 40rem
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
