<template lang="pug">
.modal-card.TurnNotificationModal
  ////////////////////////////////////////////////////////////////////////////////
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-6
      span.has-text-weight-bold
        | 手番のお知らせサポート
  ////////////////////////////////////////////////////////////////////////////////
  section.modal-card-body
    p.has-text-centered.is-size-7
      | リレー将棋で自分の手番をまちがいがちな方向けのサポート機能です<br>
      | 順序が固定されている場合に指定の上家が指し終わったときにお知らせします
    .is-flex.is-justify-content-center.is-align-items-center.mt-4
      b-select(v-model="new_name")
        option(v-for="e in base.member_infos" :value="e.from_user_name" v-text="e.from_user_name")
      p.control.ml-1
        | さんが指したら知らせる
  footer.modal-card-foot
    b-button.close_button(@click="close_handle" icon-left="chevron-left") 閉じる
    b-button.reset_button(@click="reset_button") 解除
    b-button.submit_button(@click="submit_button") 適用
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "TurnNotificationModal",
  mixins: [
    support_child,
  ],
  data() {
    return {
      new_name: null,
    }
  },
  beforeMount() {
    this.new_name = this.base.cn_from_user_name || this.primary_member_name
  },
  methods: {
    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
    reset_button() {
      this.sound_play("click")
      this.$emit("close")
    },
    submit_button() {
      this.sound_play("click")
      this.$emit("close")
    },
  },
  computed: {
    primary_member_name() {
      if (this.base.member_infos.length >= 1) {
        return this.base.member_infos[0].from_user_name
      }
    }
  },
}
</script>

<style lang="sass">
@import "support.sass"

.STAGE-development
  .TurnNotificationModal
    .modal-card-body, .field
      border: 1px dashed change_color($primary, $alpha: 0.5)

.TurnNotificationModal
  // .modal-card-body
  //   padding: 2.0rem 2.0rem
  .modal-card-foot
    justify-content: space-between
  // .field:not(:last-child)
  //   margin-bottom: 1.1rem
</style>
