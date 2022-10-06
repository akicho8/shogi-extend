<template lang="pug">
b-menu-item.is_active_unset.SwarsBattleIndexMenuItemSelect(
  v-bind="$attrs"
  v-on="$listeners"
  tag="nuxt-link"
  active-class=""
  :to="to"
  :class="{'has-text-weight-bold': active_p}"
  @click.native="click_handle"
  )
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsBattleIndexMenuItemSelect",
  mixins: [support_child],
  props: {
    query_preset_info: { type: Object, required: true },
  },
  methods: {
    click_handle() {
      this.$sound.play_click()
      this.talk(this.query_preset_info.name)
      this.remote_notify({subject: "プリセット", body: this.query_preset_info.name})
    },
  },
  computed: {
    to() {
      return { name: "swars-search", query: {query: this.new_query} }
    },
    active_p() {
      return (this.$route.query.query || "") === this.new_query
    },
    new_query() {
      return [this.base.xi.current_swars_user_key, this.query_preset_info.query].join(" ")
    },
  },
}
</script>

<style lang="sass">
.SwarsBattleIndexMenuItemSelect
</style>
