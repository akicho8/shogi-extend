<template lang="pug">
.QuickScriptView
  DebugBox(v-if="development_p" position="bottom_right")
    div g_loading_p (axios): {{g_loading_p}}
    div $fetchState.pending: {{$fetchState.pending}}
    div fetch_index: {{fetch_index}}
    div post_index: {{post_index}}
    div $user_agent_info: {{$user_agent_info}}

  DebugBox.is-hidden-mobile(v-if="development_p && params")
    | {{value_type_guess(params.body)}}

  template(v-if="development_p || true")
    //- b-loading(:active="$fetchState.pending || (params && params.button_click_loading && g_loading_p)")
    // SSR 中もローディングを出すには必ず $fetchState.pending が必要になる
    // ここからがよくわからないが CSR は $fetchState.pending と fetch() のタイミングがずれているので g_loading_p を入れている
    // ↓これをやると、talk を呼ぶだけでローディングになってしまう
    //- b-loading(:active="$fetchState.pending || g_loading_p")
    b-loading(:active="$fetchState.pending")

  component(
    v-if="main_component"
    :is="main_component['_component']"
    v-bind="main_component['_v_bind']"
    :class="main_component['class']"
    :style="main_component['style']"
  )
</template>

<script>
import _ from "lodash"
import { Gs } from "@/components/models/gs.js"
import Vue from 'vue'
import QueryString from "query-string"
import isMobile from "ismobilejs"

import { mod_value_type  } from "./mod_value_type.js"
import { mod_form        } from "./mod_form.js"
import { mod_taginput    } from "./mod_taginput.js"
import { mod_file_upload } from "./mod_file_upload.js"
import { mod_sidebar     } from "./mod_sidebar.js"
import { mod_storage     } from "./mod_storage.js"

export default {
  // scrollToTop: true,
  name: "QuickScriptView",

  mixins: [
    mod_value_type,
    mod_form,
    mod_taginput,
    mod_file_upload,
    mod_sidebar,
    mod_storage,
  ],

  provide() {
    return {
      QS: this,
    }
  },
  props: {
    // 呼び出す側で $route.params を上書きすればいいのでこれはいらない。
    // が、一つのページで QuickScriptView を二つ呼ぶ場合には使えないので一応用意しておく。
    qs_group_key: { type: String, default: null },
    qs_page_key:  { type: String, default: null },
    // $route.query に上書きする値 (このコンポーネントを部分的に呼ぶとき $route.query にマージしたいときがある)
    qs_override_params: { type: Object, default: null, },
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
    // $route.query は初回のときに使い、this.attributes は次からのときに使う → これは間違いで同じページに飛ぶとき $route.query を常に優先しないとだめ
    // axios 古すぎて paramsSerializer が効かない

    this.fetch_index ??= 0
    let params = this.new_params
    if (this.$route.query["__prefer_url_params__"]) {
      params = this.prefer_url_params
    }
    const new_params2 = {...this.invisible_params, ...params, fetch_index: this.fetch_index}
    this.$axios.$get(this.current_api_path, {
      params: this.params_serialize(new_params2),
    }).then(params => { // post にする？
      this.fetch_index += 1
      this.params_receive(params)
    })
  },

  // mounted() {
  //   // ページ読み込み時に履歴に現在のページを追加
  //   // window.addEventListener('load', () => {
  //   history.replaceState({ internal: true }, '')
  //   alert(1)
  //   // })
  //
  //   // popstate イベントを監視
  //   window.addEventListener('popstate', (event) => {
  //     alert(event.state)
  //     // 戻る先が同じサイト内かどうかを確認
  //     if (event.state && event.state.internal) {
  //       // 同じサイト内であれば、通常通り履歴を戻る
  //       console.log("Same site navigation")
  //     } else {
  //       // 外部サイトへの戻りを無効化し、カスタムアクションを実行
  //       history.go(1) // 進む
  //       console.log("Attempted to go back to an external site.")
  //     }
  //   })
  // },

  methods: {
    // :PARAMS_SERIALIZE_DESERIALIZE:
    // Rails に GET で渡したとき空配列を空配列として認識させられないため配列を文字列化する
    params_serialize(params) {
      const hv = {}
      _.forIn(params, (val, key) => {
        if (Gs.blank_p(val)) {
          val = "__empty__"
          // if (_.isArray(val)) {
          //   // 配列の場合 __empty__  にしてしまうと "" になってしまう → checkbox_button の場合でも isArray にひっかからない場合がある
          // } else {
          //   val = "__empty__"
          // }
          // } else {
          // if (_.isArray(val)) {
          //   val = "[" + val.join(",") + "]"
          // }
          // if (val === "") {
          //   val = '""'
          // }
        }
        hv[key] = val
      })
      return hv
    },
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
          if (form_part["key"]) { // これで real_static_value は除外できる
            this.$set(this.attributes, form_part["key"], form_part["default"])
          }

          // b-taginput 用の候補初期値を設定する
          if (form_part.type === "b_taginput") {
            this.taginput_init(form_part)
          }
        })

        this.qs_ls_load()
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
        const code = params["auto_exec_code"]
        if (code) {
          eval(code)
        }
      }
    },

    title_click_handle(e) {
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
      this.qs_ls_save()
      if (this.params.get_then_axios_get) {
        // URL を書き換えずにこっそり GET したい場合
        // this.sfx_play_click()
        const new_params2 = {...this.invisible_params, ...this.new_params}
        this.$axios.$get(this.current_api_path, {params: this.params_serialize(new_params2)}).then(params => this.params_receive(params))
      } else {
        // $router.push でクエリ引数を変更することで再度 fetch() が実行したい場合
        this.router_push({})
      }
    },

    post_handle() {
      if (this.action_then_nuxt_login_required()) { return }
      this.qs_ls_save()
      this.post_index ??= 0
      const new_params2 = {...this.invisible_params, ...this.new_params, post_index: this.post_index}
      this.$axios.$post(this.current_api_path, new_params2).then(params => {
        this.post_index += 1
        this.params_receive(params)
      })
    },

    router_push(params = {}) {
      const new_params2 = {...this.invisible_params, ...this.new_params, ...params} // 破壊するため
      this.browser_query_delete(new_params2)   // ブラウザ上で表示させたくないパラメータを削除する(new_params2 を破壊する)
      this.$router.push({query: this.params_serialize(new_params2)}, () => {
        this.debug_alert("$router.push 成功")
        // this.sfx_play_click()
      }, () => {
        if (this.params.router_push_failed_then_fetch) {
          this.debug_alert("$router.push 失敗 (だが自力でfetch)")
          // this.sfx_play_click()
          this.$fetch()         // Googleシートの場合はこの方法で自力で呼ぶ
        } else {
          this.debug_alert("$router.push 失敗")
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
          if (e.key) {
            delete params[e.key]
          }
        }
      })
    },

    action_then_nuxt_login_required() {
      if (this.params["nuxt_login_required_timing"] === "later") {
        if (this.nuxt_login_required()) { return true }
      }
    },

    parent_link_click_handle() {
      let v = null
      const parent_link = this.params.parent_link
      if (v = parent_link?.force_link_to) {
        this.$router.push(v)
        return
      }
      if (v = parent_link?.fallback_url) {
        this.back_to_or(v)
        return
      }
      if (true) {
        v = {name: "lab-qs_group_key-qs_page_key", params: {qs_group_key: this.current_qs_group_key}}
        this.back_to_or(v)
        return
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // Vue.js 側は URL の "foo[]=1" を {"foo" => [1]} ではなく {"foo[]": [1]} として解釈しているため
    // そのまま Rails 側に送ると foo[][]=1 となり、{foo: [[1]]} としてネストが深くなってしまう。
    // したがって "foo[]" を "foo" に直す。
    // nuxt.config.js の router.queryParser でやるのが正しいらしいが QueryString ライブラリが参照できないというしょうもない理由で諦めた。
    params_bracket_replace(params) {
      const hv = {}
      _.each(params, (value, key) => {
        const bracket_deleted_key = key.replace(/\[\]/, "") // "foo[]" => "foo"
        hv[bracket_deleted_key] = value
      })
      return hv
    },

    // 不要なパラメータを削除したパラメーター
    params_reject(params) {
      const hv = {}
      _.each(params, (value, key) => {
        if (key === "__prefer_url_params__") {
        } else {
          hv[key] = value
        }
      })
      return hv
    },
  },
  computed: {
    current_qs_group_key() { return this.qs_group_key ?? this.$route.params.qs_group_key },
    current_qs_page_key()  { return this.qs_page_key  ?? this.$route.params.qs_page_key  },
    current_api_path()     { return `/api/lab/${this.current_qs_group_key ?? '__qs_group_key_is_blank__'}/${this.current_qs_page_key ?? '__qs_page_key_is_blank__'}.json` },
    meta()                 { return this.params ? this.params.meta : null                                                                  },
    showable_form_parts()  { return this.params ? this.params["form_parts"].filter(e => e.type !== "hidden") : [] }, // hidden を除いた form パーツたち
    main_component()       { return this.params?.main_component },
    user_agent_key()       { return this.$user_agent_info.any ? "mobile" : "desktop" },

    normalized_url_params() {
      let params = this.$route.query
      params = this.params_bracket_replace(params)
      params = this.params_reject(params)
      return params
    },

    // attributes を優先したパラメーター
    new_params() {
      return {
        ...this.submit_key_params,
        // ...this.$route.query,      // ← このままGETで送ると危険。このなかには {"foo[]" => 1} という形式で入っているため Rails 側に foo[][]=1 で渡ってしまう
        ...this.normalized_url_params,
        ...this.qs_override_params,
        ...this.attributes,
      }
    },

    // URLパラメーターを優先したパラメーター
    // __prefer_url_params__ 引数が入っていれば優先してこちらを使う
    prefer_url_params() {
      return {
        ...this.qs_override_params,
        ...this.normalized_url_params,
      }
    },

    invisible_params() {
      return {
        user_agent_key: this.user_agent_key,
      }
    },

    // GET のときパラメータに付与するキー
    submit_key_params() {
      const hv = {}
      if (this.params?.params_add_submit_key) {
        hv[this.params.params_add_submit_key] = true
      }
      return hv
    },

    current_api_url()          { return `${this.$config.MY_SITE_URL}${this.current_api_path}` },                                                    // 共通の API URL
    current_api_url_internal() { return QueryString.stringifyUrl({url: this.current_api_url, query: this.new_params}) },                            // このビュー用の API URL
    current_api_url_general()  { return QueryString.stringifyUrl({url: this.current_api_url, query: {...this.new_params, json_type: "general"}}) }, // 汎用 JSON 用の URL

    // レイアウトの CSS class
    container_class() { return this.params.container_width === "large" ? "is-fluid" : "is_layout_small" },
  },
}
</script>

<style lang="sass">
.QuickScriptView
  __css_keep__: 0
</style>
