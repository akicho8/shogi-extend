<template lang="pug">
.the_header.columns
  .column
    .main_info.is-flex
      p
        | 購読数: {{$parent.ac_subscriptions_count}}
      p(v-if="$parent.online_user_ids != null")
        | オンライン: {{$parent.online_user_ids.length}}人
      p(v-if="$parent.room_user_ids != null")
        | 対戦中: {{$parent.room_user_ids.length}}人
      p(v-if="$parent.matching_list != null")
        | 対戦待ち: {{$parent.matching_list.length}}人
</template>

<script>
import the_support from './the_support.js'

export default {
  name: "the_header",
  mixins: [
    the_support,
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
@import "../stylesheets/bulma_init.scss"
.the_header
</style>
