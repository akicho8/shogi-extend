<template lang="pug">
.SwarsUserKeyDownloadAll
  b-loading(:active="$fetchState.pending")
  b-navbar(type="is-primary" :mobile-burger="false" wrapper-class="container" spaced)
    template(slot="brand")
      b-navbar-item(@click="back_handle")
        b-icon(icon="arrow-left")
      b-navbar-item.has-text-weight-bold(tag="div") {{page_title}}
    template(slot="end")
      NavbarItemLogin
      NavbarItemProfileLink

  .section
    .container
      .content
        b-notification(:closable="false")
          | 棋譜取得の予約について
          | <br><br>
          | 将棋ウォーズ棋譜検索は将棋ウォーズ公式アプリ(以下本家)とは完全には同期していません。検索という名前をつけているものの、直近の対局をすぐに検討できることを目的としているのと、本家への負荷の軽減や、レスポンス速度の兼ね合いもあって、本家から取得するのは各ルール直近10件だけにしてます。
          | そのため、たくさん対戦しているはずなのに、検索してみたら思ったより少なかったり、抜けがある状態になってしまいます。
          | <br><br>
          | たとえば、3分切れ負けをいきなり100局やったあと検索しても、直近10件しか取り込んでないので残りの90件は表示されません。最初に対局した90局を検討したかった場合は困るでしょう。
          | <br><br>
          | そんなときに下の<b>棋譜取得の予約</b>をすると本家に負荷がかかりにくいと思われる夜中に古い棋譜(※直近1ヶ月分)を取ってきます。

      b-field.mt-6(label="完了通知およびZIP送信先メールアドレス" label-position="on-border")
        b-input(v-model.trim="to_email" required)

      b-field.mt-5
        .control
          b-switch(v-model="attachment_mode" true-value="with_zip" false-value="nothing")
            | 棋譜を固めたZIPファイルを添付する

      b-field.mt-5
        .control
          .buttons
            b-button(@click="yoyaku_handle") 棋譜取得の予約
            b-button(@click="sabaku_handle_handle" v-if="development_p") さばく

  pre(v-if="development_p") {{$data}}
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
    }
  },
  fetchOnServer: false,
  fetch() {
    return this.$axios.$get("/api/settings/email_fetch").then(e => {
      this.to_email = e.email
    })
  },
  methods: {
    async yoyaku_handle() {
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
      const retv = await this.$axios.$post("/api/swars/download_yoyaku", params)
      this.notice_collector_run(retv)
    },

    async sabaku_handle_handle() {
      const retv = await this.$axios.$post("/api/swars/crawler_run")
      this.notice_collector_run(retv)
    },

    back_handle() {
      this.sound_play('click')
      this.$router.go(-1)
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
  .section
    &:first-of-type
</style>
