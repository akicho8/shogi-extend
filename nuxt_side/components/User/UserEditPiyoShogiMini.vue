<template lang="pug">
.UserEditPiyoShogiMini(v-if="new_piyo_shogi_type_key")
  .columns.is-mobile.is-multiline
    .column.is-12
      b-field(custom-class="is-small" label="ぴよ将棋ボタンの表示" :message="new_piyo_shogi_type_info.message")
        template(v-for="e in PiyoShogiTypeInfo.values")
          b-radio-button(v-model="new_piyo_shogi_type_key" :native-value="e.key" @input="$sound.play_click()")
            | {{e.name}}
  .columns.is-mobile.is-multiline
    .column.is-12
      b-field
        .control
          b-button(type="is-primary" @click="save_handle") 保存
</template>

<script>
import { PiyoShogiTypeInfo } from "@/components/models/piyo_shogi_type_info.js"
import { mod_storage } from "@/components/User/mod_storage.js"

export default {
  name: "UserEditPiyoShogiMini",
  mixins: [mod_storage],
  data() {
    return {
      new_piyo_shogi_type_key: null,
    }
  },
  mounted() {
    this.new_piyo_shogi_type_key = this.piyo_shogi_type_key
  },
  methods: {
    save_handle() {
      this.$sound.play_click()
      if (this.new_piyo_shogi_type_key != this.piyo_shogi_type_key) {
        this.piyo_shogi_type_key = this.new_piyo_shogi_type_key
        this.$PiyoShogiTypeCurrent.reset()
        this.toast_ok(`${this.piyo_shogi_type_info.name}に変更しました`)
      } else {
        this.toast_ok("変更はありませんでした")
      }
    },
  },
  computed: {
    PiyoShogiTypeInfo()    { return PiyoShogiTypeInfo                                 },
    piyo_shogi_type_info() { return PiyoShogiTypeInfo.fetch(this.piyo_shogi_type_key) },
    new_piyo_shogi_type_info() { return PiyoShogiTypeInfo.fetch(this.new_piyo_shogi_type_key) },
  },
}
</script>

<style lang="sass">
.UserEditPiyoShogiMini
  __css_keep__: 0
</style>
