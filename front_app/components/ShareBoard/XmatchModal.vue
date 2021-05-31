<template lang="pug">
.modal-card.XmatchModal
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-5.has-text-weight-bold
      | 自動マッチング
  section.modal-card-body
    template(v-if="base.ac_lobby")
      template(v-for="sbx_rule_info in base.SbxRuleInfo.values")
        a.box(@click="sbx_rule_click(sbx_rule_info)")
          .has-text-weight-bold
            | {{sbx_rule_info.name}}
          b-taglist.mt-2
            template(v-if="base.sbx_rules_members[sbx_rule_info.key]")
              template(v-for="e in base.sbx_rules_members[sbx_rule_info.key]")
                b-tag(rounded type="is-primary")
                  span(:class="user_name_class(e)")
                    | {{e.from_user_name}}
            template(v-for="i in rest_count(sbx_rule_info)")
              b-tag(rounded type="is-grey") ?

      // b-loading(:active="!base.ac_lobby")
      | {{!!base.ac_lobby}}
      pre {{base.sbx_rules_members}}

  footer.modal-card-foot
    b-button.close_button(@click="close_handle") 閉じる
    b-button.close_button(@click="test_handle" v-if="development_p") テスト
    b-button.close_button(@click="clear_handle") クリア
</template>

<script>
import _ from "lodash"
import { support_child } from "./support_child.js"

export default {
  name: "XmatchModal",
  mixins: [support_child],
  mounted() {
    this.base.lobby_create()
  },
  beforeDestroy() {
    this.base.lobby_destroy()
  },
  methods: {
    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
    test_handle() {
      this.sound_play("click")
    },
    clear_handle() {
      this.sound_play("click")
    },
    sbx_rule_click(e) {
      this.sound_play("click")
      this.base.rule_select(e)
    },

    rest_count(sbx_rule_info) {
      let r = sbx_rule_info.members_count_max - (this.base.sbx_rules_members[sbx_rule_info.key] || []).length
      if (r < 0) {
        r = 0
      }
      return r
    },

    user_name_class(e) {
      return {
        'has-text-weight-bold': e.from_connection_id === this.base.connection_id,
      }
    },
  },
}
</script>

<style lang="sass">
.XmatchModal
  height: 80vh
  +tablet
    width: 30rem
  .modal-card-body
    // padding: 0rem
    // background-color: $black-bis
    // .b-table
    //   background-color: $black-bis
  .modal-card-foot
    justify-content: space-between
    .button
      font-weight: bold
      min-width: 8rem
</style>
