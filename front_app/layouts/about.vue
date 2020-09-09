<template lang="pug">
.about
  b-navbar(type="is-orange")
    template(slot="brand")
      b-navbar-item(tag="a" :href="$config.BASE_URL")
        Logo
        span.ml-2
          b SHOGI-EXTEND
    template(slot="start")
      b-navbar-item(v-if="development_p" tag="nuxt-link" :to="{name:'index'}" exact-active-class="is-active") Home
      template(v-for="(item, key) of items")
        b-navbar-item(tag="nuxt-link" :to="item.to" exact-active-class="is-active") {{item.title}}

  .section
    .tabs.mb-6(v-if="false")
      ul
        li(v-for="(item, key) of items" :key="key" class="is-active")
          nuxt-link(:to="item.to" exact-active-class="is-active" class="is-active") {{item.title}}
    .tabs.mb-6(v-if="false")
      ul
        li
          //- nuxt-link(:to="{name: 'index'}") TOP
          a(href="/") TOP
        li(v-if="development_p")
          nuxt-link(:to="{name: 'index'}") Home
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
</style>
