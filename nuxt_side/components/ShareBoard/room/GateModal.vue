<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 入退室
      b-tag.mx-2.has-text-weight-bold(type="is-success" v-if="SB.ac_room && false") 入室中
    b-button(@click="SB.room_url_copy_handle" icon-left="link" size="is-small" rounded v-if="SB.ac_room") 部屋のリンク
  .modal-card-body
    template(v-if="SB.room_key_autocomplete_use_p")
      // b-autocomplete の場合はモーダルの中に入ってしまって使いにくい
      b-field(label="合言葉" label-position="on-border")
        b-autocomplete(
          max-height="4rem"
          v-model.trim="SB.new_room_key"
          :data="SB.room_key_autocomplete_complement_list"
          type="search"
          placeholder=""
          :open-on-focus="true"
          :clearable="false"
          expanded
          @select="SB.room_key_autocomplete_select_handle"
          @keydown.native.enter="SB.room_key_autocomplete_enter_handle"
          :disabled="SB.ac_room"
          ref="new_room_key"
          )
    template(v-else)
      // HTML5のdatalistを使った方がモーダルの上に表示できる
      b-field(label="合言葉" label-position="on-border")
        b-input.new_room_key(v-model.trim="SB.new_room_key" :disabled="SB.ac_room" ref="new_room_key" autocomplete="on" list="room_key_comp_list")
      datalist(id="room_key_comp_list")
        template(v-for="room_key in SB.complement_room_keys")
          option(:value="room_key")

    b-field(label="ハンドルネーム" label-position="on-border")
      b-input.new_user_name(v-model.trim="SB.new_user_name" :disabled="SB.ac_room" autocomplete="on")

  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="SB.gate_modal_close_handle" icon-left="chevron-left")
    template(v-if="!SB.ac_room")
      b-button.gate_enter_handle(@click="SB.gate_enter_handle" type="is-primary") 入室
    template(v-else)
      b-button.gate_leave_handle(@click="SB.gate_leave_handle" type="is-danger") 退室
</template>

<script>
import _ from "lodash"
import { GX } from "@/components/models/gx.js"

import { support_child } from "../support_child.js"

export default {
  name: "GateModal",
  mixins: [support_child],
  mounted() {
    // ショートカットキーから起動すると、そのキーを入力してしまいがちなので、合言葉が未入力のときだけフォーカスする
    if (GX.blank_p(this.SB.new_room_key)) {
      this.desktop_focus_to(this.$refs.new_room_key)
    }
  },
}
</script>

<style lang="sass">
.GateModal
  +modal_width(320px)

  .modal-card-body
    padding: 1.5rem
    li:not(:first-child)
      margin-top: 0.75rem

  .field:not(:last-child)
    margin-bottom: 1.5rem
</style>
