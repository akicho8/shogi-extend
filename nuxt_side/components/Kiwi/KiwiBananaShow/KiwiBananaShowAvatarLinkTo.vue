<template lang="pug">
.media-left.KiwiBananaShowAvatarLinkTo
  nuxt-link.image.is-square(:to="{name: 'users-id', params: {id: user.id}}" @click.native="sfx_click()")
    img.is-rounded(:src="user.avatar_path" :alt="user.name")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiBananaShowAvatarLinkTo",
  mixins: [support_child],
  props: {
    user: { type: Object, required: true },
  },
}
</script>

<style lang="sass">
@import "../all_support.sass"
.KiwiBananaShowAvatarLinkTo
  .image
    width: 32px
    +tablet
      width: 48px
</style>
