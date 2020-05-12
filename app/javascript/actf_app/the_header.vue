<template lang="pug">
.the_header.columns
  .column
    .is-flex.main_info
      p(v-if="development_p")
        | 購読数: {{$parent.ac_subscriptions_count}}
      p(v-if="$parent.online_user_ids != null")
        | オンライン: {{$parent.online_user_ids.length}}人
      p(v-if="$parent.room_user_ids != null")
        | 対戦中: {{$parent.room_user_ids.length}}人
      p(v-if="$parent.matching_list != null")
        | 対戦待ち: {{$parent.matching_list.length}}人
</template>

<script>
import support from "./support.js"

export default {
  name: "the_header",
  mixins: [
    support,
  ],
  props: {
  },
  data() {
    return {
    }
  },
  created() {
  },
  watch: {
  },
  methods: {
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_header
  .main_info
    justify-content: space-between
    font-size: $size-7
</style>
