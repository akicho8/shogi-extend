<template lang="pug">
.StopwatchHistoryModal.modal-card.is-size-7(style="width: auto")
  header.modal-card-head
    p.modal-card-title 履歴
  section.modal-card-body
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
  footer.modal-card-foot
    button.button(type="button" @click="close_handle") 閉じる
</template>

<script>
import { support } from "./support.js"

export default {
  name: "StopwatchHistoryModal",
  mixins: [
    support,
  ],
  props: {
    base: { type: Object, required: true },
  },
  mounted() {
    this.toast_ok("操作を間違えたときや以前の続きから行いたいときに過去の状態に戻れます")
  },
  methods: {
    click_handle(row) {
      this.sound_play("click")
      this.base.memento_restore(row)
      this.$emit("close")
    },
    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
  },
  computed: {
    rows() {
      return this.base.memento_list.slice().reverse()
    },
  },
}
</script>

<style lang="sass">
.StopwatchHistoryModal
  tr:hover
    cursor: pointer
  .modal-card-foot
    justify-content: flex-end
    .button
      font-weight: bold
</style>
