<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 局面の転送
  .modal-card-body
    //- p
    //-   | 現在の局面を他の人の盤に転送します。
    template(v-if="true")
      p
        | 局面の転送は着手したとき自動的に行いますが、
        | これを使うと着手しなくても現在の局面を他者に転送します
      //- p
      //-   | よくありそうな使い道は<b>反則の取り消し</b>と<b>待った</b>です。
      //-   | 本来は反則をした人が合意の上、小さい左矢印で1手戻して正しい手を指すだけでよいのですが、
      //-   | 当人が慣れていない場合は慣れている人が1手戻した局面を転送してメッセージで当人に正しい手を指すよう促せばよいです
      //- p
      //-   | 同様に<b>初期配置に戻して再度対局する</b>場合も初手を指す人が左矢印で初期配置に戻してから指せばよいのですが、わからない場合は慣れている人が初期配置に戻した盤を全員に配ってから始めるとよいです
      //- p
      //-   | その他には対局後に<b>検討したい局面</b>に合わせたり、カスタマイズした駒落ち等の初期配置を配るときにも使えます
  .modal-card-foot
    b-button.close_button(@click="close_handle" icon-left="chevron-left") やめとく
    b-button.test_button(@click="test_handle" v-if="development_p") テスト
    b-button.sync_button(@click="sync_handle" type="is-danger") 転送する
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "ForceSyncModal",
  mixins: [support_child],
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
  +modal_width(28rem)
  .modal-card-body
    padding: 1.5rem
    p:not(:first-child)
      margin-top: 0.75rem
</style>
