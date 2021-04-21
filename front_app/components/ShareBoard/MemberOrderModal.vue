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
      :data="table_rows"
      :row-class="(row, index) => !row.enabled_p && 'x-has-background-white-ter'"
      :mobile-cards="false"
      )

      b-table-column(v-slot="{row}" field="order_index" label="手番" centered :width="0")
        template(v-if="row.order_index != null")
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
      table_rows: null,
    }
  },
  beforeMount() {
    if (this.base.ordered_members == null) {
      // 1度も設定されていないので全員を「参加」状態で入れる
      this.table_rows = [...this.default_ordered_members]
    } else {
      // 1度自分で設定または他者から共有されている ordered_members を使う
      this.table_rows = [...this.base.ordered_members]

      // しかし、あとから接続して来た人たちが含まれていないため「観戦」状態で追加する
      if (true) {
        this.default_ordered_members.forEach(m => {
          if (!this.table_rows.some(e => e.user_name === m.user_name)) {
            this.table_rows.push({
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

      if (true) {
        if (this.new_ordered_members.length % 2 !== 0) {
          this.toast_warn("参加者は偶数の人数にしてください")
          return
        }
      }

      if (this.changed_p || true) {
        this.debug_alert(`ordered_members_share`)
        this.base.ordered_members_share(this.new_ordered_members)
      } else {
        if (this.base.ordered_members) {
          this.toast_ok(`すでに適用済みです`)
        }
      }

      if (this.development_p) {
      } else {
        this.$emit("close")
      }
    },

    // ↓↑を押したとき
    up_down_handle(row, sign) {
      const index = this.table_rows.findIndex(e => e.user_name === row.user_name)
      this.table_rows = this.ary_move(this.table_rows, index, index + sign)
      this.order_index_update()
    },

    enable_toggle_handle(row) {
      row.enabled_p = !row.enabled_p
      this.order_index_update()
    },

    order_index_update() {
      let index = 0
      this.table_rows.forEach(e => {
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

    changed_p() {
      return !_.isEqual(this.base.ordered_members, this.new_ordered_members)
    },

    new_ordered_members() {
      return this.table_rows.filter(e => e.enabled_p)
    },

    default_ordered_members() {
      if (this.development_p && FAKE_P) {
        return [
          "alice",
          "bob",
          "carol",
          "dave",
          "ellen",
        ].map((e, i) => ({ enabled_p: true, order_index: i, user_name: e }))
      }

      return this.base.name_uniqued_member_infos.map((e, i) => {
        return {
          enabled_p: true,
          order_index: i,
          user_name: e.from_user_name,
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
