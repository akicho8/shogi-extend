<template lang="pug">
.about
  MainNavbar
    template(slot="brand")
      b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'index'}") SHOGI-EXTEND
    template(slot="start" v-if="false")
      b-navbar-item(v-if="development_p" tag="nuxt-link" :to="{name: 'index'}" exact-active-class="is-active") Home
      template(v-for="(item, key) of items")
        b-navbar-item(tag="nuxt-link" :to="item.to" exact-active-class="is-active") {{item.title}}

  .section.pt-4
    .container
      .tabs.mb-6(v-if="false")
        ul
          li(v-for="(item, key) of items" :key="key" class="is-active")
            nuxt-link(:to="item.to" exact-active-class="is-active" class="is-active") {{item.title}}

      .tabs.mb-6(v-if="true")
        ul
          template(v-for="(item, key) of items")
            nuxt-link(:to="item.to" v-slot="{ href, route, navigate, isActive, isExactActive }")
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
.about
  .tabs ul
    +mobile
      justify-content: center
</style>
