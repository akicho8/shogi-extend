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
      b-table-column(v-slot="{row}" field="location_key" label="ﾁｰﾑ" centered)
        b-button(@click="location_toggle_handle(row)")
          | {{Location.fetch(row.location_key).name}}
      b-table-column(v-slot="{row}" field="order_index"     label="ﾁｰﾑ内の順番" centered) {{row.order_index + 1}}
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

    .py-4
      span.has-text-weight-bold 全体の順番
      .is-inline-block.ml-2
        template(v-for="(row, i) in real_order_members")
          b-tag.has-text-weight-bold(rounded :type="foo_type(row)")
            //- | {{Location.fetch(row.location_key).name}}
            | {{row.user_name}}
          span.mx-1.has-text-grey-light.is-size-7(v-if="i < real_order_members.length - 1")
            | →

  footer.modal-card-foot
    b-button.close_button(@click="close_handle" icon-left="chevron-left") 閉じる
    b-button.test_button(@click="test_handle" v-if="development_p") テスト
    b-button.apply_button(@click="apply_handle" :type="{'is-primary': form_changed_p}") 適用
</template>

<script>
import { support_child } from "./support_child.js"
import _ from "lodash"
import { Location } from "shogi-player/components/models/location.js"
import { CycleIterator } from "@/components/models/cycle_iterator.js"

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
    this.order_index_update()
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

    location_toggle_handle(row) {
      row.location_key = Location.fetch(row.location_key).flip.key
      this.order_index_update()
    },

    order_index_update() {
      this.new_ordered_members.forEach(e => {
        e.order_index = this.group_list_hash[e.location_key].findIndex(v => e.user_name === v.user_name)
      })
      // return list
      // const list = location_hash[row.location_key]
      // const index = list.findIndex(e => e.user_name === row.user_name)
      // if (index >= 0) {
      //   return index + 1
      // }
    },

    foo_type(row) {
      if (row.location_key === 'black') {
        return "is-primary"
      }
      if (row.location_key === 'white') {
        return "is-primary is-light"
      }
      return
    },
  },
  computed: {
    Location() { return Location },
    form_changed_p() {
      return this.base.ordered_members !== this.new_ordered_members
    },
    real_order_members() {
      // const location_hash = Location.values.reduce((a, e, i) => ({...a, [e.key]: 0}), {})
      // this.new_ordered_members.map(e => hash[e.location_key].push(e))

      const tmp_names = this.new_ordered_members.map(e => e.user_name)

      const cycle_list = Location.values.map(e => new CycleIterator(this.group_list_hash[e.key]))

      const list = []
      let done = false
      while (!done) {
        _.forEach(cycle_list, it => {
          const v = it.next
          list.push(v)
          _.pull(tmp_names, v.user_name)
          if (_.isEmpty(tmp_names)) {
            done = true
            return false        // break (_.forEachなら可能)
          }
        })
      }
      return list
    },
    group_list_hash() {
      const hash = Location.values.reduce((a, e, i) => ({...a, [e.key]: []}), {})
      this.new_ordered_members.forEach(e => hash[e.location_key].push(e))
      return hash
    },
    default_ordered_members() {
      if (this.development_p) {
        return [
          { order_index: null, user_name: "alice", location_key: "black", },
          { order_index: null, user_name: "bob",   location_key: "black", },
          { order_index: null, user_name: "carol", location_key: "white", },
          { order_index: null, user_name: "dave",  location_key: "white", },
          { order_index: null, user_name: "ellen", location_key: "white", },
        ]
      }

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
