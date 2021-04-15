<template lang="pug">
.modal-card.TurnNotifyModal(style="width:auto")
  ////////////////////////////////////////////////////////////////////////////////
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-6
      span.has-text-weight-bold
        | 手番が来たら知らせる設定
  ////////////////////////////////////////////////////////////////////////////////
  section.modal-card-body
    .is-flex.is-justify-content-center.is-align-items-center
      p.control
        | 上家の
      b-select.mx-1(v-model="new_previous_user_name")
        option(:value="null")
        option(v-for="e in base.member_infos" :value="e.from_user_name" v-text="e.from_user_name")
      p.control
        | さんが指したら自分だけに知らせる
    //- p.has-text-centered.is-size-7.has-text-grey-light
    //-   | リレー将棋で自分の手番をまちがいがちな方向けのサポート機能です<br>
    //-   | 順序が固定されている場合に指定の上家が指し終わったときにお知らせします
  footer.modal-card-foot
    b-button.close_button(@click="close_handle" icon-left="chevron-left") 閉じる
    b-button.test_button(@click="test_handle" v-if="development_p") テスト
    b-button.apply_button(@click="apply_handle" type="is-primary") 適用
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "TurnNotifyModal",
  mixins: [
    support_child,
  ],
  data() {
    return {
      new_previous_user_name: null,
    }
  },
  beforeMount() {
    this.new_previous_user_name = this.base.previous_user_name || this.primary_member_name
  },
  methods: {
    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
    test_handle() {
      this.sound_play("click")
      this.base.tn_notify()
    },
    apply_handle() {
      if (this.base.previous_user_name === this.new_previous_user_name) {
        if (this.base.previous_user_name) {
          this.toast_ok(`すでに適用済みです`)
        }
      } else {
        this.base.previous_user_name = this.new_previous_user_name
        if (this.base.previous_user_name) {
          const name = this.user_call_name(this.base.previous_user_name)
          this.toast_ok(`${name}が指したら牛が鳴きます`)
        } else {
          this.toast_ok(`解除しました`)
        }
      }
      this.sound_play("click")
      this.$emit("close")
    },
  },
  computed: {
    form_changed_p() {
      return this.base.previous_user_name !== this.new_previous_user_name
    },
    primary_member_name() {
      if (false) {
        if (this.base.member_infos.length >= 1) {
          return this.base.member_infos[0].from_user_name
        }
      } else {
        return null
      }
    }
  },
}
</script>

<style lang="sass">
@import "support.sass"

.STAGE-development
  .TurnNotifyModal
    .modal-card-body, .field
      border: 1px dashed change_color($primary, $alpha: 0.5)

.TurnNotifyModal
  .modal-card-foot
    justify-content: space-between
    .button
      min-width: 6rem
      font-weight: bold
</style>
