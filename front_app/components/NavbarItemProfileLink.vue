<template lang="pug">
b-navbar-item.NavbarItemProfileLink(tag="nuxt-link" :to="{name: 'users-id', params: {id: g_current_user.id}}" @click.native="sound_play('click')" v-if="g_current_user")
  .image
    img.is-rounded(:src="g_current_user.avatar_path")
</template>

<style lang="sass">
.NavbarItemProfileLink
  img
    max-height: none
    height: 32px
    width: 32px
</style>
