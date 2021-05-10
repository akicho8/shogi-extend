<template lang="pug">
.UserShow(v-if="!$fetchState.pending")
  client-only
    b-sidebar.is-unselectable.UserShow-Sidebar(fullheight right v-model="sidebar_p")
      .mx-4.my-4
        b-menu
          b-menu-list(label="Action")
            b-menu-item.is_active_unset(label="編集"               tag="nuxt-link" :to="{name: 'settings-profile'}"        @click.native="sound_play('click')")
            b-menu-item.is_active_unset(label="ぴよ将棋の種類"     tag="nuxt-link" :to="{name: 'settings-piyo_shogi'}"     @click.native="sound_play('click')")
            b-menu-item.is_active_unset(label="メールアドレス変更" tag="nuxt-link" :to="{name: 'settings-email'}"          @click.native="sound_play('click')")
            b-menu-item.is_active_unset(label="ウォーズIDの設定"   tag="nuxt-link" :to="{name: 'settings-swars-user-key'}" @click.native="sound_play('click')" v-if="development_p")
          b-menu-list(label="その他")
            b-menu-item.is_active_unset(label="アカウント連携" :href="`${$config.MY_SITE_URL}/accounts/${record.id}/edit`")
            b-menu-item.is_active_unset(label="ログアウト" @click="logout_handle")
    MainNavbar
      template(slot="brand")
        NavbarItemHome
        b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'users-id', params: {id: $route.params.id}}")
          | {{page_title}}
      template(slot="end" v-if="g_current_user && g_current_user.id === record.id")
        b-navbar-item.px_5_if_tablet(@click="sidebar_toggle")
          b-icon(icon="menu")
    MainSection
      .container
        .columns.is-centered
          .column
            .has-text-centered
              .image
                img.is-rounded.is-inline-block(:src="record.avatar_path")
            .mt-4(v-if="twitter_key")
              .has-text-weight-bold Twitter
              a(:href="twitter_url" :target="target_default") @{{twitter_key}}
            .mt-4.box.description.has-background-white-ter.is-shadowless(v-if="record.description" v-html="auto_link(record.description)")
  DebugPre(v-if="development_p") {{record}}
</template>

<script>
export default {
  name: "UserShow",
  data() {
    return {
      record: null,
      sidebar_p: false,
    }
  },
  fetch() {
    // http://0.0.0.0:3000/api/users/1.json
    // http://0.0.0.0:4000/users/1
    return this.$axios.$get(`/api/users/${this.$route.params.id}.json`).then(e => {
      this.record = e
    })
  },
  methods: {
    async logout_handle() {
      this.sound_play("click")
      await this.a_auth_user_logout()
      this.toast_ok("ログアウトしました")
    },
    sidebar_toggle() {
      this.sound_play("click")
      this.sidebar_p = !this.sidebar_p
    },
    back_handle() {
      this.sound_play("click")
      this.back_to()
    },
  },
  computed: {
    meta() {
      if (this.record) {
        return {
          title: this.page_title,
          description: this.record.description,
          og_image: this.record.avatar_path,
        }
      }
    },
    page_title() {
      if (this.record) {
        return `${this.record.name}`
      }
    },
    twitter_key() {
      if (this.record) {
        return this.record.twitter_key
      }
    },
    twitter_url() {
      if (this.twitter_key) {
        return `https://twitter.com/${this.twitter_key}`
      }
    },
  },
}
</script>

<style lang="sass">
.UserShow-Sidebar
  .sidebar-content
    width: unset
    a
      white-space: nowrap
    .menu-label:not(:first-child)
      margin-top: 2em

.UserShow
  .MainSection.section
    padding-top: 2.8rem

  .image
    img
      width: 256px

  .column
    +tablet
      max-width: 40rem

.STAGE-development
  .UserShow
    .column
      border: 1px dashed change_color($primary, $alpha: 0.1)
    .image
      border: 1px dashed change_color($danger, $alpha: 0.1)
      .FriendlyWidth
        border: 1px dashed change_color($primary, $alpha: 0.1)
</style>
