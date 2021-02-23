<template lang="pug">
.UserEditPiyoShogi.has-background-white-bis
  MainNavbar
    template(slot="start")
      b-navbar-item.has-text-weight-bold(@click="cancel_handle") キャンセル
    template(slot="end")
      b-navbar-item.has-text-weight-bold(@click="save_handle") 保存

  MainSection
    .container
      .columns.is-centered
        .column
          b-field(label="このブラウザから起動するぴよ将棋の種類の設定")
            template(v-for="e in PiyoShogiTypeInfo.values")
              b-radio-button(v-model="new_piyo_shogi_type_key" :native-value="e.key" @input="sound_play('click')")
                | {{e.name}}

          b-message.my-5(type="is-primary")
            .content
              p
                strong 自動判別
                span.ml-2 一般的なスマホやPCを使っている人用。M1 Mac を使っていない人用
              p
                strong ぴよ将棋
                span.ml-2 せっかく買った M1 Mac に「ぴよ将棋」を入れたのに「ぴよ将棋ｗ」が起動してしまう人用
              p
                strong ぴよ将棋ｗ
                span.ml-2 スマホを持っているのになんかしらの理由で「ぴよ将棋」をインストールできなかったり、「ぴよ将棋」を入れているのに「ぴよ将棋ｗ」が使いたい人用
</template>

<script>
import { PiyoShogiTypeInfo } from "../models/piyo_shogi_type_info.js"
import { app_storage } from "./app_storage.js"

export default {
  name: "UserEditPiyoShogi",
  mixins: [app_storage],
  data() {
    return {
      new_piyo_shogi_type_key: null,
    }
  },
  mounted() {
    this.new_piyo_shogi_type_key = this.piyo_shogi_type_key
  },
  meta() {
    return {
      title: this.page_title,
    }
  },
  methods: {
    cancel_handle() {
      this.sound_play("click")
      this.back_to()
    },

    save_handle() {
      this.sound_play("click")
      if (this.new_piyo_shogi_type_key != this.piyo_shogi_type_key) {
        this.piyo_shogi_type_key = this.new_piyo_shogi_type_key
        this.toast_ok(`${this.piyo_shogi_type_info.name}に変更しました`)
      } else {
        this.toast_ok("変更はありませんでした")
      }
      this.back_to()
    },
  },
  computed: {
    PiyoShogiTypeInfo()    { return PiyoShogiTypeInfo                                 },
    piyo_shogi_type_info() { return PiyoShogiTypeInfo.fetch(this.piyo_shogi_type_key) },
    page_title()           { return "ぴよ将棋の種類の変更"                            },
  },
}
</script>

<style scoped lang="sass">
.UserEditPiyoShogi
  min-height: 100vh
</style>
