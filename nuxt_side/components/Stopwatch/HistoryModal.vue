<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title 履歴
  .modal-card-body.is-size-7
    b-table(
      :data="rows"
      :paginated="false"
      :per-page="200"
      :pagination-simple="true"
      :mobile-cards="false"
      @click="click_handle"
      hoverable
      )
      b-table-column(v-slot="props" field="time"       label="日付" sortable) {{base.log_time_format(props.row.time)}}
      b-table-column(v-slot="props" field="book_title" label="ﾀｲﾄﾙ")          {{props.row.book_title}}
      b-table-column(v-slot="props" field="event"      label="ｲﾍﾞﾝﾄ")         {{props.row.event}}
      b-table-column(v-slot="props" field="track"      label="問題")          {{props.row.current_track}}
      b-table-column(v-slot="props" field="summary"    label="ｻﾏﾘ")           {{props.row.summary}}
  .modal-card-foot
    b-button.close_handle(@click="close_handle" icon-left="chevron-left") 閉じる
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "HistoryModal",
  mixins: [support_child],
  mounted() {
    this.toast_ok("操作を間違えたときや以前の続きから行いたいときに過去の状態に戻れます")
  },
  methods: {
    click_handle(row) {
      this.sfx_click()
      this.base.memento_restore(row)
      this.$emit("close")
    },
    close_handle() {
      this.sfx_click()
      this.$emit("close")
    },
  },
  computed: {
    rows() {
      return this.$gs.ary_reverse(this.base.memento_list)
    },
  },
}
</script>

<style lang="sass">
.HistoryModal
  +modal_width_auto
  tr:hover
    cursor: pointer
</style>
