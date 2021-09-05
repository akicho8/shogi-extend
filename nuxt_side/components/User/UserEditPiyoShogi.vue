<template lang="pug">
.UserEditPiyoShogi.has-background-white-bis
  MainNavbar
    template(slot="start")
      b-navbar-item.has-text-weight-bold.px_5_if_tablet(@click="cancel_handle") キャンセル
    template(slot="end")
      b-navbar-item.has-text-weight-bold.px_5_if_tablet(@click="save_handle") 保存

  MainSection(v-if="new_piyo_shogi_type_key")
    .container
      .columns.is-centered
        .column
          b-field(label="このブラウザから起動するぴよ将棋の種類" :message="new_piyo_shogi_type_info.message")
            template(v-for="e in PiyoShogiTypeInfo.values")
              b-radio-button(v-model="new_piyo_shogi_type_key" :native-value="e.key" @input="sound_play('click')")
                | {{e.name}}
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
    new_piyo_shogi_type_info() { return PiyoShogiTypeInfo.fetch(this.new_piyo_shogi_type_key) },
    page_title()           { return "ぴよ将棋の種類の変更"                            },
  },
}
</script>

<style scoped lang="sass">
.UserEditPiyoShogi
  min-height: 100vh
</style>
