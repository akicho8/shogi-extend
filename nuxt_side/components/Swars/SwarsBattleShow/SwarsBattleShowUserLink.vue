<template lang="pug">
nuxt-link.SwarsBattleShowUserLink(
  :to="{name: 'swars-users-key', params: {key: membership.user.key}, query: {query: query}}"
  @click.native.stop="sfx_click()"
  :class="css_class"
  )
  span(:class="`has-text-${membership.location_key}`" v-if="with_location") ☗
  span.ml-1(v-if="with_user_key") {{membership.user.key}}
  span.ml-1 {{membership.grade_info.name}}
  span.mx-1(v-if="membership.user.ban_at") 💀
  span.ml-1(v-if="with_judge && membership.judge_key !== 'lose'") ({{judge_info.name}})
</template>

<script>
import { JudgeInfo } from "../../models/judge_info.js"

export default {
  props: {
    membership:    { required: true     },
    with_user_key: { default: true      },
    with_location: { default: false     },
    with_judge:    { default: false     },
    query:         { default: undefined }, // null にしてはいけない。null なら URL が "query=" になってしまう 
  },
  computed: {
    JudgeInfo()  { return JudgeInfo                                       },
    judge_info() { return this.JudgeInfo.fetch(this.membership.judge_key) },

    css_class() {
      if (this.membership.judge_key) {
        return `is-${this.membership.judge_key}`
      }
    },
  },
}
</script>

<style lang="sass">
.SwarsBattleShowUserLink
  font-weight: normal
  &.is-win
    font-weight: bold
</style>
