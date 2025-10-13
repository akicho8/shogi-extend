<template lang="pug">
.WkbkUserName
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
import { support } from "./support.js"
export default {
  name: "WkbkUserName",
  mixins: [support],
  props: {
    user: { type: Object, required: true, },
  },
}
</script>

<style lang="sass">
@import "./support.sass"
.WkbkUserName
  a
    color: unset

  .image
    img
      max-height: none
      height: 18px
      width:  18px
</style>
