<template lang="pug">
.SwarsUserKeyDownloadAll
  b-loading(:active="$fetchState.pending")
  MainNavbar
    template(slot="brand")
      b-navbar-item(@click="back_handle")
        b-icon(icon="chevron-left")
      b-navbar-item.has-text-weight-bold(tag="div") {{page_title}}
    template(slot="end")
      NavbarItemLogin
      NavbarItemProfileLink

  MainSection
    .container
      template(v-if="!g_current_user")
        b-notification(type="is-warning")
          | この機能を使う場合はいったんログインしてください

      b-notification(:closable="false")
        .title.is-5 棋譜取得の予約について
        | 将棋ウォーズ棋譜検索は将棋ウォーズ公式(以下本家)とはあんまり同期していません。
        | 検索という名前をつけているものの、直近の対局をすぐに検討できることを目的としているのと、本家への負荷軽減や、レスポンス速度の兼ね合いもあって、本家から取得するのは各ルール直近10件だけにしています。
        | <br><br>
        | そのため、たくさん対戦しているはずなのに検索してみたら思ったより表示件数が少なかったとか、一覧で見ると抜けができたりします。
        | <br><br>
        | たとえば、3分切れ負けをいきなり15局やったあと検索しても直近の10局しか取り込んでないので残り5局が見当たりません。
        | 最初に対局した5局のなかに検討したかった対局がある場合は困るでしょう。
        | <br><br>
        | そんなときに<b>棋譜取得の予約</b>をすると残りの5局を取ってきます。
        | 深夜に古い棋譜(※最大直近1ヶ月分)を探しに行きます。
        | 終わったら指定のメールアドレスに通知します。
        | その際に棋譜データも必要であればZIPファイルの添付を有効にしてください。

      b-field.mt-6(label="通知先メールアドレス" label-position="on-border")
        b-input(v-model.trim="to_email" required :disabled="!g_current_user")

      b-field.mt-5
        .control
          b-switch(v-model="attachment_mode" true-value="with_zip" false-value="nothing" :disabled="!g_current_user")
            | 棋譜をZIPファイルにして添付

      b-field.mt-5
        .control
          .buttons
            b-button(@click="yoyaku_handle" :disabled="!g_current_user" :loading="loading_p") 棋譜取得の予約
            b-button(@click="crawler_run_handle_handle" v-if="development_p") さばく

  DebugPre {{$data}}
</template>

<script>
export default {
  name: "SwarsUserKeyDownloadAll",
  head() {
    return {
      title: this.page_title,
      meta: [
        { hid: "og:title",       property: "og:title",       content: this.page_title, },
        { hid: "og:description", property: "og:description", content: "",              },
      ],
    }
  },
  data() {
    return {
      to_email: null,
      attachment_mode: "nothing",
      loading_p: false,
    }
  },
  fetchOnServer: false,
  fetch() {
    if (this.g_current_user) {
      return this.$axios.$get("/api/settings/email_fetch").then(e => {
        this.to_email = e.email
      })
    }
  },
  methods: {
    async yoyaku_handle() {
      if (!this.g_current_user) {
        this.toast_ng("ログインしてください")
        return
      }

      if (!this.to_email) {
        this.toast_ng("メールアドレスを入力してください")
        return
      }

      const params = {
        crawl_reservation: {
          target_user_key: this.$route.params.key,
          to_email:        this.to_email,
          attachment_mode: this.attachment_mode,
        },
      }
      this.loading_p = true
      const retv = await this.$axios.$post("/api/swars/download_set", params)
      this.loading_p = false
      this.notice_collector_run(retv)
    },

    async crawler_run_handle_handle() {
      const retv = await this.$axios.$post("/api/swars/crawler_run")
      this.notice_collector_run(retv)
    },

    back_handle() {
      this.sound_play('click')
      this.back_to({name: "swars-search", query: {query: this.$route.params.key}})
    },
  },
  computed: {
    page_title() {
      return `${this.$route.params.key}さんの古い棋譜を取得`
    },
  },
}
</script>

<style lang="sass">
.SwarsUserKeyDownloadAll
  .MainSection
    .container
      max-width: 65ch ! important
    .notification
      padding-right: 1.25rem // notification はなぜか右のpaddingが広くなっているため左と同じにする
</style>
