<template lang="pug">
//- .modal-card.MemberOrderModal(style="width:auto")
.modal-card.MemberOrderModal
  ////////////////////////////////////////////////////////////////////////////////
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-6
      span.has-text-weight-bold
        | 手番通知一括設定
  ////////////////////////////////////////////////////////////////////////////////
  section.modal-card-body
    //- hr
    //- b-taglist
    //-   template(v-for="row in default_ordered_members")
    //-     b-tag(rounded type="is-primary")
    //-       | {{row.from_user_name}}
    //- .buttons
    //-   template(v-for="row in default_ordered_members")
    //-     b-button(rounded type="is-primary" size="is-small" @click="user_name_click(row)")
    //-       | {{row.from_user_name}}
    //- 
    //- hr
    //- | {{new_ordered_members}}
    b-table(
      :data="new_ordered_members"
      )
      //- :paginated="true"
      //- :per-page="base.config.per_page"
      //- :current-page.sync="base.current_pages[base.current_rule_index]"
      //- :pagination-simple="false"
      //- :mobile-cards="false"
      //- :row-class="(row, index) => row.id === (base.time_record && base.time_record.id) && 'is-selected'"
      //- :narrowed="true"
      //- )
      //- default-sort-direction="desc"
      b-table-column(v-slot="{row}" field="user_name"    label="名前") {{row.user_name}}
      b-table-column(v-slot="{row}" field="location_key" label="先後") {{Location.fetch(row.location_key)}}
      //- b-table-column(v-slot="props" field="entry_name" label="名前"  sortable) {{string_truncate(props.row.entry_name || '？？？', {length: 15})}}
      //- b-table-column(v-slot="props" field="spent_sec"  label="タイム") {{base.time_format_from_msec(props.row.spent_sec)}}
      //- b-table-column(v-slot="props" field="created_at" label="日付" :visible="!!base.curent_scope.date_visible") {{base.time_default_format(props.row.created_at)}}

    //- .is-flex.is-justify-content-center.is-align-items-center
    //-   p.control
    //-     | 上家の
    //-   b-select.mx-1(v-model="new_ordered_members")
    //-     option(:value="null")
    //-     option(v-for="e in base.member_infos" :value="e.from_user_name" v-text="e.from_user_name")
    //-   p.control
    //-     | さんが指したら自分だけに知らせる
    //- p.has-text-centered.is-size-7.has-text-grey-light
    //-   | リレー将棋で自分の手番をまちがいがちな方向けのサポート機能です<br>
    //-   | 順序が固定されている場合に指定の上家が指し終わったときにお知らせします
  footer.modal-card-foot
    b-button.close_button(@click="close_handle" icon-left="chevron-left") 閉じる
    b-button.test_button(@click="test_handle" v-if="development_p") テスト
    b-button.apply_button(@click="apply_handle" :type="{'is-primary': form_changed_p}") 適用
</template>

<script>
import { support_child } from "./support_child.js"
import _ from "lodash"
import { Location   } from "shogi-player/components/models/location.js"

export default {
  name: "MemberOrderModal",
  mixins: [
    support_child,
  ],
  data() {
    return {
      new_ordered_members: null,
    }
  },
  beforeMount() {
    this.new_ordered_members = [...(this.base.ordered_members || this.default_ordered_members)]
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
      if (_.isEqual(this.base.ordered_members, this.new_ordered_members)) {
        if (this.base.ordered_members) {
          this.toast_ok(`すでに適用済みです`)
        }
      } else {
        this.base.ordered_members = [...this.new_ordered_members]
        if (this.base.ordered_members) {
          const name = this.user_call_name(this.base.ordered_members)
          this.toast_ok(`${name}が指したら牛が鳴きます`)
        } else {
          this.toast_ok(`解除しました`)
        }
      }
      this.sound_play("click")
      this.$emit("close")
    },

    user_name_click(row) {
      this.new_ordered_members.push(row)
    },
  },
  computed: {
    form_changed_p() {
      return this.base.ordered_members !== this.new_ordered_members
    },
    default_ordered_members() {
      let v = this.base.member_infos
      v = _.uniqBy(v, "from_user_name")
      v = v.map((e, i) => {
        return {
          user_name: e.from_user_name,
          location_key: Location.fetch(i).key,
        }
      })
      return v
    }
  },
}
</script>

<style lang="sass">
@import "support.sass"

.STAGE-development
  .MemberOrderModal
    .modal-card-body, .field
      border: 1px dashed change_color($primary, $alpha: 0.5)

.MemberOrderModal
  .modal-card-foot
    justify-content: space-between
    .button
      min-width: 6rem
      font-weight: bold
</style>
