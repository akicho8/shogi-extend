<template lang="pug">
.about-layout
  MainNavbar
    template(slot="brand")
      HomeNavbarItem
      b-navbar-item.has-text-weight-bold About

  .section.pt-4
    .container
      .tabs.mb-6(v-if="false")
        ul
          li(v-for="(item, key) of items" :key="key" class="is-active")
            nuxt-link(:to="item.to" exact-active-class="is-active" class="is-active") {{item.title}}

      .tabs.mb-6(v-if="true")
        ul
          template(v-for="(item, key) of items")
            nuxt-link(:to="item.to" v-slot="{ href, route, navigate, isActive, isExactActive }" @click.native="sound_play('click')")
              li(:class="[isActive && 'is-active', isExactActive && '']")
                a(:href="href" @click="navigate") {{item.title}}
      nuxt
</template>

<script>
export default {
  name: "about",
  data () {
    return {
      items: [
        { title: "プレイバシー",   to: { name: "about-privacy-policy" }, },
        { title: "利用規約",       to: { name: "about-terms"          }, },
        { title: "クレジット",     to: { name: "about-credit"         }, },
      ]
    }
  },
}
</script>

<style lang="sass">
.about-layout
  .tabs ul
    +mobile
      justify-content: center
</style>
