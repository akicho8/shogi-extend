<template lang="pug">
.modal-card.XmatchModal(style="width:auto")
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-5.has-text-weight-bold
      | 自動マッチング
    p.is-size-5(v-if="base.current_xmatch_rule_key && base.xmatch_rest_seconds >= 1")
      | {{base.xmatch_rest_seconds}}

  section.modal-card-body
    b-loading(:is-full-page="true" :active="!base.xmatch_rules_members")
    template(v-if="base.xmatch_rules_members")
      .columns.is-multiline.is-variable.is-2
        template(v-for="xmatch_rule_info in base.XmatchRuleInfo.values")
          .column.is-one-third.py-2
            a.box(@click="xmatch_rule_click(xmatch_rule_info)")
              .has-text-weight-bold.is-size-4.is_line_break_off
                | {{xmatch_rule_info.name}}
              .has-text-grey-light.is-size-7.is_line_break_off
                | {{xmatch_rule_info.rule_desc}}
              b-taglist.mt-2(v-if="active_count(xmatch_rule_info) >= 1 || true")
                template(v-if="base.xmatch_rules_members[xmatch_rule_info.key]")
                  template(v-for="e in base.xmatch_rules_members[xmatch_rule_info.key]")
                    b-tag(rounded type="is-primary")
                      span(:class="user_name_class(e)")
                        | {{e.from_user_name}}
                template(v-for="i in rest_count(xmatch_rule_info)")
                  b-tag(rounded type="is-grey") ?

      // b-loading(:active="!base.ac_lobby")
      //- | {{!!base.ac_lobby}}
      //- pre {{base.xmatch_rules_members}}

  footer.modal-card-foot
    b-button.cancel_handle(@click="cancel_handle") キャンセル
    b-button.unselect_handle(@click="unselect_handle") 選択解除
</template>

<script>
import _ from "lodash"
import { support_child } from "./support_child.js"

export default {
  name: "XmatchModal",
  mixins: [support_child],
  mounted() {
    this.base.lobby_create()    // ac_lobby を作る
  },
  beforeDestroy() {
    this.base.xmatch_interval_counter.stop()
    this.base.rule_unselect()
    this.base.lobby_destroy()
  },
  methods: {
    cancel_handle() {
      this.sound_play("click")
      this.base.rule_unselect()
      this.$emit("close")
    },
    unselect_handle() {
      this.sound_play("click")
      this.base.rule_unselect()
    },
    xmatch_rule_click(e) {
      this.sound_play("click")
      if (this.base.current_xmatch_rule_key === e.key) {
        this.base.rule_unselect()
      } else {
        this.base.xmatch_interval_counter.restart()
        this.base.rule_select(e)
      }
    },

    // マッチング中の人数
    active_count(e) {
      this.__assert__(this.base.xmatch_rules_members, "this.base.xmatch_rules_members")
      return this.base.xmatch_rules_members[e.key].length
    },

    // あとN人いれば成立する
    rest_count(e) {
      let r = e.members_count_max - this.active_count(e)
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
  min-height: 30vh

  // height: 80vh
  // +tablet
  //   width: 30rem
  .modal-card-head
    p
      line-height: 1
  .modal-card-body
    padding: 1.25rem 1rem
    // padding: 0rem
    // background-color: $black-bis
    // .b-table
    //   background-color: $black-bis
    .box
      display: flex
      align-items: center
      justify-content: center
      flex-direction: column

  .modal-card-foot
    justify-content: space-between
    .button
      font-weight: bold
      min-width: 8rem
.STAGE-development
  .XmatchModal
    // .columns
    //   border: 1px dashed change_color($primary, $alpha: 0.5)
    // .column
    //   border: 1px dashed change_color($danger, $alpha: 0.5)
</style>
