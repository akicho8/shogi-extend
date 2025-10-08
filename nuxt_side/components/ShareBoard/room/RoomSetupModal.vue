<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 入退室
      b-tag.mx-2.has-text-weight-bold(type="is-success" v-if="SB.ac_room && false") 入室中
    b-button(@click="SB.room_url_copy_handle" icon-left="link" size="is-small" rounded v-if="SB.ac_room") 部屋のリンク
  .modal-card-body
    template(v-if="SB.rsm_autocomplete_use_p")
      // b-autocomplete の場合はモーダルの中に入ってしまって使いにくい
      b-field(label="合言葉" label-position="on-border")
        b-autocomplete(
          max-height="4rem"
          v-model.trim="SB.new_room_key"
          :data="SB.rsm_complement_list_for_ac"
          type="search"
          placeholder=""
          :open-on-focus="true"
          :clearable="false"
          expanded
          @select="SB.rsm_autocomplete_select_handle"
          @keydown.native.enter="SB.rsm_autocomplete_enter_handle"
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
    b-button.close_handle.has-text-weight-normal(@click="SB.rsm_close_handle" icon-left="chevron-left")
    template(v-if="!SB.ac_room")
      b-button.room_entry_button(@click="SB.rsm_entry_handle" type="is-primary") 入室
    template(v-else)
      b-button.room_leave_button(@click="SB.rsm_leave_handle" type="is-danger") 退室
</template>

<script>
import _ from "lodash"
import { Gs } from "@/components/models/gs.js"

import { support_child } from "../support_child.js"

export default {
  name: "RoomSetupModal",
  mixins: [support_child],
  mounted() {
    // ショートカットキーから起動すると、そのキーを入力してしまいがちなので、合言葉が未入力のときだけフォーカスする
    if (Gs.blank_p(this.SB.new_room_key)) {
      this.desktop_focus_to(this.$refs.new_room_key)
    }
  },
}
</script>

<style lang="sass">
.RoomSetupModal
  +modal_width(320px)

  .modal-card-body
    padding: 1.5rem
    li:not(:first-child)
      margin-top: 0.75rem

  .field:not(:last-child)
    margin-bottom: 1.5rem
</style>
