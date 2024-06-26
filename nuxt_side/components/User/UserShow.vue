<template lang="pug">
.UserShow(v-if="!$fetchState.pending")
  client-only
    b-sidebar.is-unselectable.UserShow-Sidebar(fullheight right overlay v-model="sidebar_p")
      .mx-4.my-4
        .is-flex.is-justify-content-space-between.is-align-items-center
          b-button.px-5(@click="sidebar_toggle" icon-left="menu")
        .mt-0
          b-menu
            b-menu-list(label="Action")
              b-menu-item.is_active_unset(label="プロフィール編集"   tag="nuxt-link" :to="{name: 'settings-profile'}"        @click.native="$sound.play_click()")
              b-menu-item.is_active_unset(label="メールアドレス変更" tag="nuxt-link" :to="{name: 'settings-email'}"          @click.native="$sound.play_click()")
              b-menu-item.is_active_unset(label="ウォーズIDの設定"   tag="nuxt-link" :to="{name: 'settings-swars-user-key'}" @click.native="$sound.play_click()" v-if="development_p")
              b-menu-item.is_active_unset(label="ぴよ将棋の種類"     tag="nuxt-link" :to="{name: 'settings-piyo_shogi'}"     @click.native="$sound.play_click()")
            b-menu-list(label="その他")
              b-menu-item.is_active_unset(label="アカウント連携" :href="`${$config.MY_SITE_URL}/accounts/${record.id}/edit`")
              b-menu-item.is_active_unset(label="ログアウト" @click="auth_user_logout_handle")
              b-menu-item.is_active_unset(label="退会"       @click="auth_user_destroy_handle")
    MainNavbar
      template(slot="brand")
        NavbarItemHome
        b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'users-id', params: {id: $route.params.id}}")
          | {{page_title}}
      template(slot="end" v-if="g_current_user && g_current_user.id === record.id")
        NavbarItemSidebarOpen(@click="sidebar_toggle")
    MainSection
      .container
        .columns.is-centered
          .column
            b-message(type="is-danger" :closable="false" v-if="record.permit_tag_list.includes('ban')")
              | このアカウントの利用を制限しています

            .has-text-centered
              .image
                img.is-rounded.is-inline-block(:src="record.avatar_path")
            .mt-4(v-if="twitter_key")
              .has-text-weight-bold Twitter
              a(:href="twitter_url" :target="target_default") @{{twitter_key}}
            .mt-4.box.description.has-background-white-ter.is-shadowless(v-if="record.description" v-html="$gs.auto_link(record.description)")
  DebugPre(v-if="development_p") {{record}}
</template>

<script>
import { mod_sidebar } from "./mod_sidebar.js"

export default {
  name: "UserShow",
  mixins: [mod_sidebar],
  data() {
    return {
      record: null,
    }
  },
  fetch() {
    // http://localhost:3000/api/users/1.json
    // http://localhost:4000/users/1
    return this.$axios.$get(`/api/users/${this.$route.params.id}.json`).then(e => {
      this.record = e
    })
  },
  methods: {
    async auth_user_logout_handle() {
      this.$sound.play_click()
      await this.a_auth_user_logout()
      this.toast_ok("ログアウトしました")
      this.$router.push("/")
    },
    auth_user_destroy_handle() {
      this.$sound.play_click()
      this.dialog_confirm({
        message: "退会してもよろしいですか？",
        confirmText: "退会する",
        type: "is-danger",
        onConfirm: () => {
          this.$sound.play_click()
          this.a_auth_user_destroy({fake: this.$route.query.fake}).then(() => {
            this.toast_ok("退会しました")
            this.$router.push("/")
          })
        },
      })
    },
    back_handle() {
      this.$sound.play_click()
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
    // width: unset
    a
      white-space: nowrap
    .menu-label
      margin-top: 2.5em

.UserShow
  .MainSection.section
    +tablet
      padding-top: 2.8rem
    +mobile
      padding-top: 2.0rem

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
</style>
