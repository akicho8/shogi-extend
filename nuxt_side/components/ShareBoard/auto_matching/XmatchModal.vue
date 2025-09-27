<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 自動マッチング
    p(v-if="SB.current_xmatch_rule_key && SB.xmatch_rest_seconds >= 1")
      | {{SB.xmatch_rest_seconds}}
    a(@click="SB.handle_name_modal_handle" v-if="!SB.current_xmatch_rule_key && $gs.present_p(SB.user_name)")
      b-icon(icon="pencil-outline" size="is-small")
      span.ml-1 {{SB.user_name}}
  .modal-card-body
    b-loading(:is-full-page="true" :active="!SB.xmatch_rules_members")
    template(v-if="SB.xmatch_rules_members")
      .columns.is-mobile.is-multiline.is-variable.is-2-tablet.is-1-mobile
        template(v-for="e in SB.XmatchRuleInfo.values")
          .column.is-one-third(v-if="e.stage_only.includes($config.STAGE)")
            a.box(@click="rule_click_handle($event, e)" :class="[e.key, {is_entry_active: entry_count(e) >= 1}]")
              .name {{e.name}}
              .rule_desc {{e.rule_desc}}
              b-tag.mt-2(rounded type="is-primary is-light" v-if="rest_count(e) >= 1")
                | あと{{rest_count(e)}}人
              .names_list.mt-2(v-if="entry_count(e) >= 1")
                // エントリー者を並べる
                template(v-for="e in SB.xmatch_rules_members[e.key]")
                  b-tag(rounded type="is-primary")
                    span(:class="user_name_class(e)")
                      | {{$gs.str_truncate(e.from_user_name, {length: 8 + 3})}}
                //- 空席を並べる
                //- template(v-for="i in rest_count(e)")
                //-   b-tag.is-hidden-mobile(rounded type="is-grey") ?

      // b-loading(:active="!SB.ac_lobby")
      //- | {{!!SB.ac_lobby}}
      //- pre {{SB.xmatch_rules_members}}

  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left") やめる
    b-button(size="is-small" @click="SB.xmatch_interval_counter_rest_n(3)" v-if="SB.current_xmatch_rule_key && development_p") 残3
    b-button.unselect_handle(@click="unselect_handle") 選択解除
</template>

<script>
import _ from "lodash"
import { support_child } from "../support_child.js"
import { HandleNameValidator } from '@/components/models/handle_name/handle_name_validator.js'

export default {
  name: "XmatchModal",
  mixins: [support_child],
  beforeDestroy() {
    this.SB.xmatch_rule_key_reset()
    this.SB.lobby_destroy()
  },
  methods: {
    // やめる
    close_handle() {
      this.sfx_click()
      this.SB.rule_unselect("${name}がやめました")
      this.$emit("close")
    },

    // 選択解除
    unselect_handle() {
      this.sfx_click()
      this.SB.rule_unselect("${name}が解除しました")
    },

    // ルール選択
    rule_click_handle(event, e) {
      this.sfx_click()

      // 要はハンドルネームがないのが問題なのでログインしているかどうかではなく
      // if (this.$gs.blank_p(this.SB.user_name)) { とする手もある
      // が、捨てハンと問題行動の増加で荒れる。なのできちんとログインさせる
      // ログインする気にない人にまで配慮して匿名で使ってもらおうとしてはいけない(重要)
      if (this.$gs.present_p(this.SB.xmatch_auth_key)) {
        if (this.SB.xmatch_auth_info.key === "login_required") {
          if (this.nuxt_login_required()) { return }
        }
        if (this.SB.xmatch_auth_info.key === "handle_name_required") {
          if (HandleNameValidator.invalid_p(this.SB.user_name)) {
            this.toast_warn("ログインするかハンドルネームを入力してください")
            this.SB.handle_name_modal_core({success_callback: () => this.rule_click_core(e) }) // 入力後にクリックしている
            return
          }
        }
      }

      this.rule_click_core(e)
    },
    rule_click_core(e) {
      if (this.SB.current_xmatch_rule_key === e.key) {
        this.SB.rule_unselect("${name}が解除しました")
      } else {
        this.SB.xmatch_interval_counter.restart()
        this.SB.rule_select(e)
      }
    },

    // 指定ルールにエントリーした人数
    entry_count(e) {
      this.$gs.assert(this.SB.xmatch_rules_members, "this.SB.xmatch_rules_members")
      return this.SB.xmatch_rules_members[e.key].length
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
        'has-text-weight-bold': e.from_connection_id === this.SB.connection_id,
      }
    },
  },
}
</script>

<style lang="sass">
.XmatchModal
  +modal_width(640px)

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

  +tablet
    .modal-card-body
      padding: 1.25rem 1rem
      .column
        padding-top: 0.5rem
        padding-bottom: 0.5rem

  +mobile
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
