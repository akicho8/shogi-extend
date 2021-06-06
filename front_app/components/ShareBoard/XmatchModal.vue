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
        template(v-for="e in base.XmatchRuleInfo.values")
          .column.is-one-third.py-2(v-if="e.stage_only.includes($config.STAGE)")
            a.box(@click="xmatch_rule_click(e)" :class="e.key")
              .has-text-weight-bold.is-size-4.is_line_break_off
                | {{e.name}}
              .has-text-grey-light.is-size-7.is_line_break_off
                | {{e.rule_desc}}
              b-taglist.mt-2(v-if="entry_count(e) >= 1 || true")
                template(v-if="base.xmatch_rules_members[e.key]")
                  template(v-for="e in base.xmatch_rules_members[e.key]")
                    b-tag(rounded type="is-primary")
                      span(:class="user_name_class(e)")
                        | {{e.from_user_name}}
                template(v-for="i in rest_count(e)")
                  b-tag(rounded type="is-grey") ?

      // b-loading(:active="!base.ac_lobby")
      //- | {{!!base.ac_lobby}}
      //- pre {{base.xmatch_rules_members}}

  footer.modal-card-foot
    b-button.close_button(@click="close_handle" icon-left="chevron-left") やめる
    b-button(size="is-small" @click="base.xmatch_interval_counter_rest_n(3)" v-if="base.current_xmatch_rule_key && development_p") 残3
    b-button.unselect_handle(@click="unselect_handle" v-if="development_p") 選択解除
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
    // やめる
    close_handle() {
      this.sound_play("click")
      this.base.rule_unselect()
      this.$emit("close")
    },

    // 選択解除
    unselect_handle() {
      this.sound_play("click")
      this.base.rule_unselect()
    },

    // ルール選択
    xmatch_rule_click(e) {
      this.sound_play("click")

      // 要はハンドルネームがないのが問題なのでログインしているかどうかではなく
      // if (this.blank_p(this.base.user_name)) { とする手もある
      // が、捨てハンと問題行動の増加で荒れる。なのできちんとログインさせる
      // ログインする気にない人にまで配慮して匿名で使ってもらおうとしてはいけない(重要)
      if (this.base.xmatch_login === "on") {
        if (this.sns_login_required()) {
          return
        }
      }

      if (this.base.current_xmatch_rule_key === e.key) {
        this.base.rule_unselect()
      } else {
        this.base.xmatch_interval_counter.restart()
        this.base.rule_select(e)
      }
    },

    // 指定ルールにエントリーした人数
    entry_count(e) {
      this.__assert__(this.base.xmatch_rules_members, "this.base.xmatch_rules_members")
      return this.base.xmatch_rules_members[e.key].length
    },

    // 指定ルールはあとN人いれば成立する
    rest_count(e) {
      let r = e.members_count_max - this.entry_count(e)
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
    > *
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
      &.close_handle
      &.unselect_handle
        font-weight: bold
        min-width: 8rem
.STAGE-development
  .XmatchModal
    // .columns
    //   border: 1px dashed change_color($primary, $alpha: 0.5)
    // .column
    //   border: 1px dashed change_color($danger, $alpha: 0.5)
</style>
