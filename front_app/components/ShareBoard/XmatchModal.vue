<template lang="pug">
.modal-card
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-5.has-text-weight-bold
      | 自動マッチング
    p.is-size-5(v-if="base.current_xmatch_rule_key && base.xmatch_rest_seconds >= 1")
      | {{base.xmatch_rest_seconds}}

  section.modal-card-body
    b-loading(:is-full-page="true" :active="!base.xmatch_rules_members")
    template(v-if="base.xmatch_rules_members")
      .columns.is-mobile.is-multiline.is-variable.is-2-tablet.is-1-mobile
        template(v-for="e in base.XmatchRuleInfo.values")
          .column.is-one-third(v-if="e.stage_only.includes($config.STAGE)")
            a.box(@click="rule_click_handle(e)" :class="e.key")
              .name {{e.name}}
              .rule_desc {{e.rule_desc}}
              b-tag.mt-2(rounded type="is-primary is-light" v-if="rest_count(e) >= 1")
                | あと{{rest_count(e)}}人
              .names_list.mt-2(v-if="entry_count(e) >= 1")
                // エントリー者を並べる
                template(v-for="e in base.xmatch_rules_members[e.key]")
                  b-tag(rounded type="is-primary")
                    span(:class="user_name_class(e)")
                      | {{e.from_user_name}}
                //- 空席を並べる
                //- template(v-for="i in rest_count(e)")
                //-   b-tag.is-hidden-mobile(rounded type="is-grey") ?

      // b-loading(:active="!base.ac_lobby")
      //- | {{!!base.ac_lobby}}
      //- pre {{base.xmatch_rules_members}}

  footer.modal-card-foot
    b-button.close_button(@click="close_handle" icon-left="chevron-left") やめる
    b-button(size="is-small" @click="base.xmatch_interval_counter_rest_n(3)" v-if="base.current_xmatch_rule_key && development_p") 残3
    b-button.unselect_handle(@click="unselect_handle") 選択解除
</template>

<script>
import _ from "lodash"
import { support_child } from "./support_child.js"
import { HandleNameValidator } from '@/components/models/handle_name_validator.js'

export default {
  name: "XmatchModal",
  mixins: [support_child],
  beforeDestroy() {
    this.base.xmatch_rule_key_reset()
    this.base.lobby_destroy()
  },
  methods: {
    // やめる
    close_handle() {
      this.sound_play("click")
      this.base.rule_unselect("${name}がやめました")
      this.$emit("close")
    },

    // 選択解除
    unselect_handle() {
      this.sound_play("click")
      this.base.rule_unselect("${name}が解除しました")
    },

    // ルール選択
    rule_click_handle(e) {
      this.sound_play("click")

      // 要はハンドルネームがないのが問題なのでログインしているかどうかではなく
      // if (this.blank_p(this.base.user_name)) { とする手もある
      // が、捨てハンと問題行動の増加で荒れる。なのできちんとログインさせる
      // ログインする気にない人にまで配慮して匿名で使ってもらおうとしてはいけない(重要)
      if (this.present_p(this.base.xmatch_auth_mode)) {
        if (this.base.xmatch_auth_mode === "login_required") {
          if (this.sns_login_required()) {
            return
          }
        }
        if (this.base.xmatch_auth_mode === "handle_name_required") {
          if (!HandleNameValidator.valid(this.base.user_name)) {
            this.toast_warn("ログインするかハンドルネームを入力してください")
            this.base.handle_name_modal_core()
            return
          }
        }
      }

      if (this.base.current_xmatch_rule_key === e.key) {
        this.base.rule_unselect("${name}が解除しました")
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

    // 自分の名前だけ色を濃くする
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
  .modal-card-head
    > *
      line-height: 1
  .modal-card-body
    .box
      display: flex
      align-items: center
      justify-content: center
      flex-direction: column
      .name
        font-weight: bold
        font-size: $size-5
      .rule_desc
        color: $grey-light
        font-size: $size-7
      .names_list
        display: flex
        align-items: center
        justify-content: center
        flex-wrap: wrap
        .tag
          margin: calc(0.25rem / 2)

  .modal-card-foot
    justify-content: space-between
    .button
      &.close_handle
      &.unselect_handle
        min-width: 8rem

  +tablet
    .animation-content
      max-width: 640px // $buefy.modal.open({width: 640}) 相当
      .modal-card
        width: auto    // buefyのデモを参考
        .modal-card-body
          padding: 1.25rem 1rem
          .column
            padding-top: 0.5rem
            padding-bottom: 0.5rem

  +mobile
    .animation-content
      max-width: 96vw
      .modal-card
        max-height: 90vh
        .modal-card-body
          padding: 1.25rem 0.75rem
          .column
            padding-top: 0.25rem
            padding-bottom: 0.25rem
            .box
              padding: 0.75rem

.STAGE-development
  .XmatchModal
    .columns
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .column
      border: 1px dashed change_color($danger, $alpha: 0.5)
</style>
