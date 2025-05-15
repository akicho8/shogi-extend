<template lang="pug">
MainNavbar.QuickScriptViewNavbar(:wrapper-class="['container', QS.container_class].join(' ')" v-if="QS.params.navibar_show")
  template(slot="brand")
    NavbarItemHome(icon="chevron-left" to="" tag="a" href="#" @click.native.prevent="QS.parent_link_click_handle")

    // タイトルをクリックしたときの挙動
    template(v-if="QS.meta.title")
      template(v-if="QS.params.title_link === 'url_path_reset'")
        b-navbar-item(tag="nuxt-link" :to="{}" @click.native="QS.title_click_handle")
          h1 {{QS.meta.title}}
      template(v-else)
        b-navbar-item(tag="span")
          h1 {{QS.meta.title}}

  template(slot="end")
    template(v-for="e in QS.params.header_link_items")
      template(v-if="e.type === 't_nuxt_link'")
        b-navbar-item(tag="nuxt-link" v-bind="e.params") {{e.name}}
      template(v-if="e.type === 't_link_to'")
        b-navbar-item(tag="a" v-bind="e.params") {{e.name}}

    b-navbar-item(tag="a" :href="QS.current_api_url_general" target="_blank" v-if="QS.params.general_json_link_show") JSON
    b-navbar-item(tag="a" :href="QS.current_api_url_internal" target="_blank" v-if="development_p") API
    NavbarItemLogin(      v-if="QS.params.login_link_show")
    NavbarItemProfileLink(v-if="QS.params.login_link_show")
    NavbarItemSidebarOpen(@click="QS.sidebar_toggle" v-if="QS.params.sideber_menu_show")
</template>

<script>
export default {
  name: "QuickScriptViewNavbar",
  inject: ["QS"],
}
</script>

<style lang="sass">
.QuickScriptViewNavbar
  h1, .navbar-item
    font-weight: bold
</style>
