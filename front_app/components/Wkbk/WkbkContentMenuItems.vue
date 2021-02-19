<template lang="pug">
b-menu-list.WkbkContentMenuItems(label="コンテンツ")
  b-menu-item(tag="nuxt-link" :to="{name: 'rack-articles'}" label="問題リスト"   @click.native="sound_play('click')" icon="menu")
  b-menu-item(tag="nuxt-link" :to="{name: 'rack-books'}"    label="問題集リスト" @click.native="sound_play('click')")
</template>

<script>
import { support } from "./support.js"

export default {
  name: "WkbkContentMenuItems",
  mixins: [support],
}
</script>

<style lang="sass">
@import "./support.sass"
.WkbkContentMenuItems
</style>
