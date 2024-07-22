<template lang="pug">
.QuickScriptView
  DebugBox(v-if="development_p" position="bottom_right")
    div g_loading_p (axios): {{g_loading_p}}
    div $fetchState.pending: {{$fetchState.pending}}
    div fetch_index: {{fetch_index}}
    div post_index: {{post_index}}

  DebugBox.is-hidden-mobile(v-if="development_p && params")
    | {{value_type_guess(params.body)}}

  template(v-if="development_p || true")
    //- b-loading(:active="$fetchState.pending || (params && params.button_click_loading && g_loading_p)")
    // SSR 中もローディングを出すには必ず $fetchState.pending が必要になる
    // ここからがよくわからないが CSR は $fetchState.pending と fetch() のタイミングがずれているので g_loading_p を入れている
    b-loading(:active="$fetchState.pending || g_loading_p")

  component(v-if="params?.main_component" :is="params.main_component")
</template>

<script>
import _ from "lodash"
import { Gs } from "@/components/models/gs.js"
import Vue from 'vue'
const QueryString = require("query-string")

import { mod_value_type } from "./mod_value_type.js"
import { mod_file_upload } from "./mod_file_upload.js"

export default {
  // scrollToTop: true,
  name: "QuickScriptView",

  mixins: [
    mod_value_type,
    mod_file_upload,
  ],

  provide() {
    return {
      QS: this,
    }
  },
  props: {
    // 呼び出す側で $route.params を上書きすればいいのでこれはいらない。
    // が、一つのページで QuickScriptView を二つ呼ぶ場合には使えないので一応用意しておく。
    qs_group_key: { type: String },
    qs_page_key:  { type: String },
  },
  data() {
    return {
      attributes: {},      // form 入力値
      params: null,        // サーバーから受け取った値(更新禁止)
      fetch_index: null,   // fetch するごとに 0 からインクメントする
      post_index: null,    // POST するごとに 0 からインクメントする
    }
  },
  watch: {
    // クエリ部分(例えば page=1 など)が $router.push で変化したとき $fetch を呼ぶ。
    "$route.query": "$fetch",
  },

  // https://qiita.com/crml1206/items/24bf29bc36566f4cc68d
  // true にするとソースを読むとしたときも fetch() が呼ばれてタイトルが埋め込まれている
  // しかし http://localhost:4000/lab/dev に SSR でアクセスできなくなる
  fetchOnServer: false,

  // async fetch({ $axios, error }) {
  //   try {
  //     const response = await $axios.$get(this.current_api_path, {params: {...this.$route.query, _setup: true}})
  //     console.log(response)
  //     this.params_receive(response)
  //   } catch (e) {
  //     if (e.response && e.response.status === 401) {
  //       console.log("401 エラーが発生した場合、クライアントサイドで再度 fetch する")
  //       return { retry: true };
  //     }
  //     // その他のエラーを処理
  //     error({ statusCode: e.response.status, message: e.message });
  //   }
  // },

  fetch() {
    // 初回以降も呼ばれるため attributes をまぜる
    // $route.query は初回のときに使い、this.attributes は次からのときに使う
    this.fetch_index ??= 0
    const new_params = {...this.new_params, fetch_index: this.fetch_index}
    this.$axios.$get(this.current_api_path, {params: new_params}).then(params => {
      this.fetch_index += 1
      this.params_receive(params)
    })
  },

  methods: {
    params_receive(params) {
      // fetchOnServer: true のときに実行すると this.toast_ok がないと言われる
      if (process.client) {
        // メッセージ
        // リダイレクトの前に設定すること
        if (_.isPlainObject(params.flash)) {
          this.toast_ok(params.flash["notice"])
          this.toast_ng(params.flash["alert"])
        }

        // リダイレクト
        // CSV にリダイレクトした場合などは現在のページから遷移しないため redirect_to が入っているからといって return してはいけない。
        const redirect_to = params["redirect_to"]
        if (redirect_to) {
          const to = redirect_to["to"]
          const type = redirect_to["type"]
          if (false) {
          } else if (type === "hard") {
            window.location.href = to
          } else if (type === "tab_open") {
            this.other_window_open(to)
          } else {
            this.$router.push(to)
          }
          // ここで return するべからず
        }
      }

      // 受けとる (と、次のフレームでユーザーは画面の更新に気づく)
      this.params = params

      // フォームの初期値を埋める
      if (this.params["form_parts"]) {
        this.params["form_parts"].forEach(form_part => {
          this.$set(this.attributes, form_part["key"], form_part["default"])
        })
      }

      // CSS を付け加える
      if (this.params["custom_style"]) {
        const style = document.createElement("style")
        style.textContent = this.params["custom_style"]
        this.$el.append(style)
      }

      // いきなりログインの選択肢を出す
      if (this.params["nuxt_login_required_timing"] === "immediately") {
        if (this.nuxt_login_required()) { return }
      }

      // 最後に特定のメソッドを実行する
      // もともと nuxt_login_required を呼ぶために用意していたがわかりにくいのでやめた。
      // いまはとくに使っていない。
      if (true) {
        const action = params["auto_exec_action"]
        if (action) {
          this[action]()
        }
      }
    },

    title_click_handle() {
      //
    },

    attr_value(form_part) {
      return this.attributes[form_part.key]
    },
    attr_update(form_part, value) {
      this.$set(this.attributes, form_part.key, value)
    },

    // b-table の @sort と @page-change に反応
    page_change_or_sort_handle(params) {
      this.router_push(params)  // 疑問: ページ切り替えはずっと GET と考えていたけど、別にPOSTでもよくない？
    },

    get_handle() {
      if (this.action_then_nuxt_login_required()) { return }
      if (this.params.get_then_axios_get) {
        // URL を書き換えずにこっそり GET したい場合
        // this.$sound.play_click()
        this.$axios.$get(this.current_api_path, {params: this.new_params}).then(params => this.params_receive(params))
      } else {
        // $router.push でクエリ引数を変更することで再度 fetch() が実行したい場合
        this.router_push()
      }
    },

    post_handle() {
      if (this.action_then_nuxt_login_required()) { return }
      this.post_index ??= 0
      this.$axios.$post(this.current_api_path, {...this.new_params, post_index: this.post_index}).then(params => {
        this.post_index += 1
        this.params_receive(params)
      })
    },

    router_push(params = {}) {
      const new_params2 = {...this.new_params, ...params} // 破壊するため
      this.browser_query_delete(new_params2)   // ブラウザ上で表示させたくないパラメータを削除する(new_params2 を破壊する)
      this.$router.push({query: new_params2}, () => {
        this.debug_alert("Navigation succeeded")
        // this.$sound.play_click()
      }, () => {
        this.debug_alert("Navigation failed")
        if (this.params.router_push_failed_then_fetch) {
          // this.$sound.play_click()
          this.$fetch()         // Googleシートの場合はこの方法で自力で呼ぶ
        } else {
          // this.toast_ok(`もう${this.params.button_label}しました`)
        }
      })
      // ここで $fetch を呼ぶと $route.query の更新より前に呼ばれてしまう
      // ブロックの中で呼ぶのが正しい
    },

    // ブラウザで見える GET パラメータを隠す
    // params 自体を破壊する
    // これによって気軽に直リンクされることがなくなる
    browser_query_delete(params) {
      this.params["form_parts"].forEach(e => {
        if (e.hidden_on_query) {
          delete params[e.key]
        }
      })
    },

    action_then_nuxt_login_required() {
      if (this.params["nuxt_login_required_timing"] === "later") {
        if (this.nuxt_login_required()) { return true }
      }
    },
  },
  computed: {
    current_qs_group() { return this.qs_group_key ?? this.$route.params.qs_group_key },
    current_qs_key()   { return this.qs_page_key  ?? this.$route.params.qs_page_key  },
    current_api_path() { return `/api/lab/${this.current_qs_group ?? '__qs_group_key_is_blank__'}/${this.current_qs_key ?? '__qs_page_key_is_blank__'}.json` },
    meta()             { return this.params ? this.params.meta : null                                                                  },
    showable_form_parts() { return this.params ? this.params["form_parts"].filter(e => e.type !== "hidden") : [] }, // hidden を除いた form パーツたち

    new_params() { return {...this.submit_key_params, ...this.$route.query, ...this.attributes} },

    // GET のときパラメータに付与するキー
    submit_key_params() {
      const hv = {}
      if (this.params?.params_add_submit_key) {
        hv[this.params.params_add_submit_key] = true
      }
      return hv
    },

    // ブラウザでAPIに直アクセスして戻値を確認するためのURL (フォームの入力値付き)
    current_api_url()  {
      const url = `${this.$config.MY_SITE_URL}${this.current_api_path}`
      return QueryString.stringifyUrl({url: url, query: this.new_params})
    },

    // レイアウトの CSS class
    layout_size_class() { return this.params.layout_size == "large" ? "is-fluid" : "is_layout_small" }
  },
}
</script>

<style lang="sass">
.QuickScriptView
  __css_keep__: 0
</style>
