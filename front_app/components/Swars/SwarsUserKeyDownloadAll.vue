<template lang="pug">
.SwarsUserKeyDownloadAll
  b-loading(:active="$fetchState.pending")
  MainNavbar
    template(slot="brand")
      b-navbar-item(@click="back_handle")
        b-icon(icon="chevron-left")
      b-navbar-item.has-text-weight-bold.is-size-7-mobile(tag="div") {{page_title}}
    template(slot="end")
      NavbarItemLogin
      NavbarItemProfileLink

  MainSection
    .container
      template(v-if="!g_current_user")
        b-notification(type="is-warning" :closable="false")
          | この機能を使う場合はいったんログインしてください

      b-notification(:closable="false")
        .title.is-5 棋譜取得の予約について
        | 将棋ウォーズ棋譜検索は将棋ウォーズの公式(以下本家)とはあまり同期していません。
        | 検索という名前をつけているものの、直近の対局をすぐに検討できることを目的としているのと、本家への負荷軽減や、レスポンス速度の兼ね合いもあって、本家から取得するのは各ルール直近10件だけにしています。
        | <br><br>
        | そのためたくさん対戦しているはずなのに検索してみたら思ったより表示件数が少なかったり抜けができたりします。
        | <br><br>
        | たとえば3分切れ負けを15局やったあと検索しても直近の10局しか取り込んでないので残り5局が見当たりません。
        | 最初の5局の中に検討したかった対局がある場合は困るでしょう。
        | <br><br>
        | そのようなときに<b>棋譜取得の予約</b>をすると残りの5局を取ってきます。
        | 最大直近1ヶ月分を<b>深夜</b>に探しに行きます。
        | 終わったら指定のメールアドレスに通知します。
        | その際に棋譜データも必要であればZIPファイルの添付を有効にしてください。
        | <br><br>
        | ZIPファイルには文字コード UTF-8 と Shift_JIS の両方を入れているので、古い Windows アプリで読めないときは Shift_JIS の方を使ってください。

      b-field.mt-6(label="通知先メールアドレス" label-position="on-border")
        b-input(v-model.trim="to_email" required :disabled="!g_current_user")

      b-field.mt-5
        .control
          b-switch(v-model="attachment_mode" true-value="with_zip" false-value="nothing" :disabled="!g_current_user")
            | ZIPファイルの添付

      b-field.mt-5
        .control
          .buttons
            b-button(@click="yoyaku_handle" :disabled="!g_current_user" :loading="loading_p" icon-left="clock") 棋譜取得の予約
            b-button(@click="crawler_run_handle_handle" v-if="development_p") さばく

  DebugPre {{$data}}
</template>

<script>
export default {
  name: "SwarsUserKeyDownloadAll",
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
        this.toast_warn("ログインしてください")
        return
      }

      if (!this.to_email) {
        this.toast_warn("メールアドレスを入力してください")
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
    meta() {
      return {
        title: this.page_title,
        og_title: this.page_title,
        og_description: "",
      }
    },
    page_title() {
      return `${this.$route.params.key}さんの古い棋譜を補完`
    },
  },
}
</script>

<style lang="sass">
.SwarsUserKeyDownloadAll
  .MainSection.section
    .container
      max-width: 65ch
    .notification
      padding-right: 1.25rem // notification はクローズボタンを考慮して右のpaddingが広くなっているため左と同じにする
</style>
