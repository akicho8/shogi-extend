<template lang="pug">
.media-left.GalleryBananaShowAvatarLinkTo
  nuxt-link.image.is-square(:to="{name: 'users-id', params: {id: user.id}}" @click.native="sound_play('click')")
    img.is-rounded(:src="user.avatar_path" :alt="user.name")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "GalleryBananaShowAvatarLinkTo",
  mixins: [support_child],
  props: {
    user: { type: Object, required: true },
  },
}
</script>

<style lang="sass">
@import "../all_support.sass"
.GalleryBananaShowAvatarLinkTo
  .image
    width: 32px
    +tablet
      width: 48px
</style>
