<template lang="pug">
MainNavbar.QuickScriptViewNavbar(:wrapper-class="['container', QS.layout_size_class].join(' ')" v-if="QS.params.navibar_show")
  template(slot="brand")
    template(v-if="$route.path === '/lab'")
      // レベル1: サイトトップまで上がる
      NavbarItemHome(icon="chevron-left" :to="{path: '/'}")
    template(v-else-if="QS.current_qs_key == null")
      // レベル2: グループ一覧を表示する
      NavbarItemHome(icon="chevron-left" :to="{path: '/lab'}")
    template(v-else)
      // レベル3: グループ内を表示する
      NavbarItemHome(icon="chevron-left" :to="{name: 'lab-qs_group_key-qs_page_key', params: {qs_group_key: QS.current_qs_group}}")

    // タイトルをクリックしたときは query を外す
    b-navbar-item(tag="nuxt-link" :to="{}" @click.native="QS.title_click_handle" v-if="QS.meta.title")
      h1.has-text-weight-bold {{QS.meta.title}}

  template(slot="end")
    b-navbar-item(tag="a" :href="QS.current_api_url" target="_blank" v-if="development_p") API
    NavbarItemLogin(      v-if="QS.params.login_link_show")
    NavbarItemProfileLink(v-if="QS.params.login_link_show")

</template>

<script>
export default {
  name: "QuickScriptViewNavbar",
  inject: ["QS"],
}
</script>

<style lang="sass">
.QuickScriptViewNavbar
  __css_keep__: 0
</style>
