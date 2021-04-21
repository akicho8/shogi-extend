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
    b-table(
      :data="new_ordered_members"
      :row-class="(row, index) => !row.enabled_p && 'x-has-background-white-ter'"
      :mobile-cards="false"
      )

      b-table-column(v-slot="{row}" field="order_index" label="手番" centered :width="0")
        template(v-if="row.order_index != null")
          //- b-tag(rounded)
          | {{row.order_index + 1}}

      b-table-column(v-slot="{row}" field="user_name" label="面子")
        span(:class="{'x-has-text-weight-bold': row.enabled_p}")
          | {{row.user_name}}

      b-table-column(v-slot="{row}" field="enabled_p"   label="参加" centered)
        b-button(size="is-small" @click="enable_toggle_handle(row)" :type="{'is-primary': row.enabled_p}")
          template(v-if="row.enabled_p")
            | OK
          template(v-else)
            | 観戦

      b-table-column(v-slot="{row}" custom-key="operation" label="" :width="0" centered cell-class="px-1")
        template(v-if="row.enabled_p || true")
          b-button(     size="is-small" icon-left="arrow-up"   @click="up_down_handle(row,-1)")
          b-button.ml-1(size="is-small" icon-left="arrow-down" @click="up_down_handle(row, 1)")

  footer.modal-card-foot
    b-button.close_button(@click="close_handle" icon-left="chevron-left") 閉じる
    b-button.test_button(@click="test_handle" v-if="development_p") テスト
    b-button.apply_button(@click="apply_handle" :type="{'is-primary': changed_p}") 適用
</template>

<script>
const FAKE_P = true

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
      // checked_rows: [],
    }
  },
  beforeMount() {
    if (this.base.ordered_members == null) {
      // 1度も設定されていないので全員を「参加」状態で入れる
      this.new_ordered_members = [...this.default_ordered_members]
    } else {
      // 1度自分で設定または他者から共有されている ordered_members を使う
      this.new_ordered_members = [...this.base.ordered_members]

      // しかし、あとから接続して来た人たちが含まれていないため「観戦」状態で追加する
      if (false) {
        this.default_ordered_members.forEach(m => {
          if (!this.new_ordered_members.some(e => e.user_name === m.user_name)) {
            this.new_ordered_members.push({
              ...m,
              order_index: null,  // 順番なし
              enabled_p: false,   // 観戦
            })
          }
        })
      }
    }
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
      this.sound_play("click")

      if (false) {
        if (this.real_order_members.length % 2 !== 0) {
          this.toast_warn("参加者は偶数の人数にしてください")
          return
        }
      }

      if (_.isEqual(this.base.ordered_members, this.real_order_members)) {
        if (this.base.ordered_members) {
          this.toast_ok(`すでに適用済みです`)
        }
      } else {
        this.base.ordered_members = [...this.real_order_members]
        this.base.ordered_members_share()
        if (this.base.ordered_members) {
          // const name = this.user_call_name(this.base.ordered_members)
          this.toast_ok(`設定しました`)
        } else {
          this.toast_ok(`解除しました`)
        }
      }

      // this.$emit("close")
    },

    // ↓↑を押したとき
    up_down_handle(row, sign) {
      const index = this.new_ordered_members.findIndex(e => e.user_name === row.user_name)
      this.new_ordered_members = this.ary_move(this.new_ordered_members, index, index + sign)
      this.order_index_update()
    },

    enable_toggle_handle(row) {
      row.enabled_p = !row.enabled_p
      this.order_index_update()
    },

    order_index_update() {
      let index = 0
      this.new_ordered_members.forEach(e => {
        if (e.enabled_p) {
          e.order_index = index
          index += 1
        } else {
          e.order_index = null
        }
      })
    },
  },
  computed: {
    Location() { return Location },
    form_changed_p() {
      return this.base.ordered_members !== this.new_ordered_members
    },
    real_order_members() {
      // if (this.group_members_most_min === 0) {
      //   return []
      // }

      // const location_hash = Location.values.reduce((a, e, i) => ({...a, [e.key]: 0}), {})
      // this.new_ordered_members.map(e => hash[e.location_key].push(e))

      return this.new_ordered_members.filter(e => e.enabled_p)

      // const names = this.new_ordered_members.filter(e => e.enabled_p).map(e => e.user_name)
      // const its = Location.values.map(e => new CycleIterator(this.group_hash[e.key]))
      //
      // const list = []
      // let done = false
      // while (!done) {
      //   _.forEach(its, it => {
      //     const e = it.next
      //     list.push(e)
      //     _.pull(names, e.user_name)
      //     if (_.isEmpty(names)) {
      //       done = true
      //       return false        // break (_.forEachなら可能)
      //     }
      //   })
      // }
      // return list
    },

    group_hash() {
      const hash = Location.values.reduce((a, e, i) => ({...a, [e.key]: []}), {})
      this.new_ordered_members.forEach(e => {
        if (e.enabled_p) {
          hash[e.location_key].push(e)
        }
      })
      return hash
    },

    // どちらかのグループの所属メンバーの数の一番小さい値
    group_members_most_min() {
      return Math.min(..._.map(this.group_hash, (ary, key) => ary.length))
    },

    // 1人も所属していない側のキー "black" or "white" を返す
    empty_group_location() {
      const key = _.findKey(this.group_hash, (ary, key) => ary.length === 0) // group_hash.find { |k, v| v.empty? }.first
      return Location.fetch_if(key)
    },

    default_ordered_members() {
      if (this.development_p) {
        return [
          { enabled_p: true, order_index: null, user_name: "alice", location_key: "black", },
          { enabled_p: true, order_index: null, user_name: "bob",   location_key: "black", },
          { enabled_p: true, order_index: null, user_name: "carol", location_key: "white", },
          { enabled_p: true, order_index: null, user_name: "dave",  location_key: "white", },
          { enabled_p: true, order_index: null, user_name: "ellen", location_key: "white", },
        ]
      }

      return this.name_uniqued_member_infos.map((e, i) => {
        return {
          enabled_p: true,
          order_index: i,
          user_name: e.from_user_name,
          // location_key: Location.fetch(i).key,
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
  .table
    td
      vertical-align: center

  .modal-card-foot
    justify-content: space-between
    .button
      min-width: 6rem
      font-weight: bold
</style>
