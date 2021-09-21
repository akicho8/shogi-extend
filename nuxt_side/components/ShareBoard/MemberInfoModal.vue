<template lang="pug">
.modal-card
  ////////////////////////////////////////////////////////////////////////////////
  .modal-card-head
    .modal-card-title
      | {{member_info.from_user_name}}

  ////////////////////////////////////////////////////////////////////////////////
  .modal-card-body
    .table-container
      table.table.is-fullwidth
        tbody
          template(v-for="row in table_rows")
            tr(v-if="row.enabled || development_p")
              th {{row.label}}
              td.is_line_break_on(:class="row.value_class")
                template(v-if="typeof row.value === 'function'")
                  | {{row.value()}}
                template(v-else)
                  | {{row.value}}
                span.mx-1(v-if="row.desc" v-text="row.desc" :class="row.desc_class")

    .box(v-if="development_p && false")
      | {{member_info}}

  .modal-card-foot
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
          enabled: true,
          label: "通信状況",
          value: this.base.member_net_level(this.member_info),
        },
        {
          enabled: true,
          label: "接続切れ",
          value: `${this.number_floor(this.base.member_disconnected_count_per_min(this.member_info), 2)}回/1分 計${this.member_info.ac_events_hash.disconnected || 0}回`,
        },
        {
          enabled: true,
          label: "接続",
          value: `${this.member_info.ac_events_hash.connected || 0}回`,
        },
        {
          enabled: true,
          label: "端末",
          value: this.base.UaIconInfo.fetch(this.member_info.ua_icon_key).name,
        },
        {
          enabled: true,
          label: "生存通知",
          value: `直近${this.seconds_ago(this.member_info.performed_at)} 計${this.member_info.alive_notice_count}回`,
        },
        {
          enabled: true,
          label: "入室日時",
          value: `${this.seconds_ago(this.member_info.room_joined_at)}`,
        },
        {
          enabled: true,
          label: "役割",
          value: this.base.member_status_label(this.member_info),
        },
        {
          enabled: true,
          label: "手番",
          value: this.base.order_display_index(this.member_info) ?? "なし",
        },
        {
          enabled: true,
          label: "画面フォーカス",
          value: this.member_info.window_active_p ? "ON" : "OFF (よそ見中)",
          // desc: this.member_info.window_active_p ? null : "よそ見中",
          // desc_class: "has-text-danger",
        },
        {
          enabled: true,
          label: "情報信頼レベル",
          value: this.member_info.active_level,
        },
        {
          enabled: true,
          label: "イベント受信",
          value: `${this.member_info.ac_events_hash.received || 0}回 リジェクト${this.member_info.ac_events_hash.rejected || 0}回`,
        },
        {
          enabled: true,
          label: "接続ID",
          value: this.member_info.from_connection_id,
        },
        {
          enabled: true,
          label: "API Version",
          value: this.member_info.API_VERSION,
        },
        {
          enabled: true,
          label: "ブラウザ",
          value: this.member_info.user_agent,
          value_class: "is-size-7",
        },
        {
          enabled: this.staff_p || this.$config.STAGE === "staging",
          label: "IP",
          value: this.base.config.record.remote_ip,
        },
        {
          enabled: this.staff_p || this.$config.STAGE === "staging",
          label: "Gateway",
          value: this.base.config.record.remote_name,
        },
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
