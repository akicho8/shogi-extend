<template lang="pug">
b-menu-item.SwarsBattleIndexFilterMenuItem(
  v-bind="$attrs"
  v-on="$listeners"
  tag="nuxt-link"
  :to="to"
  :class="{'has-text-weight-bold': active_p}"
  @click.native="sound_play('click')"
  )
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsBattleIndexFilterMenuItem",
  mixins: [
    support_child,
  ],
  props: {
    q: { type: String, required: true },
  },
  methods: {
  },
  computed: {
    to() {
      return {name: "swars-search", query: {query: this.new_query}}
    },
    active_p() {
      return (this.$route.query.query || "") === this.new_query
    },
    new_query() {
      return [this.base.config.current_swars_user_key, this.q].join(" ")
    },
  },
}
</script>

<style lang="sass">
.SwarsBattleIndexFilterMenuItem
</style>
