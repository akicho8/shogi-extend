<template lang="pug">
.KiwiUserName
  .box
    | 未使用
  nuxt-link(:to="{name: 'users-id', params: {id: user.id}}")
    .is-inline-flex.is-align-items-center
      .image.is-flex-shrink-0
        img.is-rounded(:src="user.avatar_path")
      .ml-1.is-hidden-mobile
        | {{$GX.str_truncate(user.name, {length: s_config.TRUNCATE_MAX})}}
</template>

<script>
import { all_support } from "./all_support.js"
export default {
  name: "KiwiUserName",
  mixins: [all_support],
  props: {
    user: { type: Object, required: true, },
  },
}
</script>

<style lang="sass">
@import "./all_support.sass"
.KiwiUserName
  a
    color: unset

  .image
    img
      max-height: none
      height: 18px
      width:  18px
</style>
