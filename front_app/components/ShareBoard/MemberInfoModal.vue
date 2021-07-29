<template lang="pug">
.modal-card
  ////////////////////////////////////////////////////////////////////////////////
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-5.has-text-weight-bold
      | {{member_info.from_user_name}}

  ////////////////////////////////////////////////////////////////////////////////
  section.modal-card-body
    .table-container
      table.table.is-fullwidth
        tbody
          tr(v-for="row in table_rows")
            th {{row.label}}
            td
              template(v-if="typeof row.value === 'function'")
                | {{row.value()}}
              template(v-else)
                | {{row.value}}
              span.mx-1(v-if="row.desc" v-text="row.desc" :class="row.desc_class")

    .box(v-if="development_p && false")
      | {{member_info}}

  footer.modal-card-foot
    b-button.close_handle(@click="close_handle" icon-left="chevron-left") 閉じる
    b-button.ping_handle(@click="ping_handle" type="is-primary") PING
</template>

<script>
import { support_child } from "./support_child.js"
import dayjs from "dayjs"

export default {
  name: "MemberInfoModal",
  mixins: [
    support_child,
  ],
  props: {
    member_info: { type: Object, required: true, },
  },
  methods: {
    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
    ping_handle() {
      // this.sound_play("click")
      this.base.member_info_ping_handle(this.member_info)
      // this.$emit("close")
    },
    seconds_ago(v) {
      const seconds = Math.ceil((this.time_current_ms() - v) / 1000)
      if (seconds < 60) {
        return `${seconds}秒前`
      } else {
        return this.diff_time_format(v)
      }
    },
  },
  computed: {
    table_rows() {
      return [
        {
          label: "通信状況",
          value: this.base.member_net_level(this.member_info),
        },
        {
          label: "接続切れ",
          value: `${this.number_floor(this.base.member_disconnected_count_per_min(this.member_info), 2)}回/1分 計${this.member_info.ac_events_hash.disconnected || 0}回`,
        },
        {
          label: "接続",
          value: `${this.member_info.ac_events_hash.connected || 0}回`,
        },
        {
          label: "端末",
          value: this.base.UaIconInfo.fetch(this.member_info.ua_icon_key).name,
        },
        {
          label: "最終生存通知",
          value: `${this.seconds_ago(this.member_info.performed_at)}`,
        },
        {
          label: "入室日時",
          value: `${this.seconds_ago(this.member_info.room_joined_at)}`,
        },
        {
          label: "役割",
          value: this.base.member_status_label(this.member_info),
        },
        {
          label: "画面フォーカス",
          value: this.member_info.window_active_p ? "ON" : "OFF (よそ見中)",
          // desc: this.member_info.window_active_p ? null : "よそ見中",
          // desc_class: "has-text-danger",
        },
        {
          label: "情報信頼レベル",
          value: this.member_info.active_level,
        },
        {
          label: "イベント受信",
          value: `${this.member_info.ac_events_hash.received || 0}回`,
        },
        {
          label: "イベント受信拒否",
          value: `${this.member_info.ac_events_hash.rejected || 0}回`,
        },
        {
          label: "接続ID",
          value: this.member_info.from_connection_id,
        },
        {
          label: "API Version",
          value: this.member_info.API_VERSION,
        },
        // {
        //   label: "霊圧",
        //   value: this.base.member_alive_p(this.member_info) ? "あり" : "なし",
        // },
      ]
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.MemberInfoModal
  +tablet
    .animation-content
      max-width: 640px // $buefy.modal.open({width: 640}) 相当
      .modal-card
        width: auto    // buefyのデモを参考
        .modal-card-body
          padding: 1.25rem
  +mobile
    .animation-content
      max-width: 96vw
      .modal-card
        max-height: 90vh
        .modal-card-body
          padding: 1.25rem 0.75rem

  th:not([align])
    white-space: nowrap
    text-align: right
    width: 1%

  .modal-card-foot
    justify-content: space-between
    .button
      min-width: 6rem
      font-weight: bold
</style>
