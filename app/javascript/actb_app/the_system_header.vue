<template lang="pug">
.the_system_header.is-flex
  p(v-if="development_p")
    | 購読:{{app.ac_subscription_names}}
  p(v-if="app.online_user_ids != null")
    | オンライン:{{app.online_user_ids.length}}人
  p(v-if="app.matching_list_hash")
    | 対戦待ち:{{app.matching_list_hash.marathon_rule.length}},{{app.matching_list_hash.singleton_rule.length}}人
  p(v-if="app.battle_user_ids != null")
    | 対戦中:{{app.battle_user_ids.length}}人
</template>

<script>
import { support } from "./support.js"

export default {
  name: "the_system_header",
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
.the_system_header
  position: fixed
  top: 48px
  right: 0
  justify-content: space-between
  p
    font-size: $size-7
    margin-left: 0.5rem
</style>
