<template lang="pug">
  b-navbar-item(tag="nuxt-link" :to="{name: 'index'}" @click.native="sound_play('click')")
    b-icon(icon="home")
</template>
