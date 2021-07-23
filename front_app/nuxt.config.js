import dayjs from "dayjs"

const BUILD_VERSION = dayjs().format("YYYY-MM-DD HH:mm:ss")

const SITE_DESC = [
  "将棋のいろんなツールを提供するサイト",
  "将棋ウォーズ棋譜検索",
  "リレー将棋・ネット対戦・詰将棋作成",
  "符号練習",
  "問題集作成",
  "棋譜の各種フォーマット変換",
  "奨励会三段リーグ個人成績確認",
  "将棋ウォーズの段級・戦法・囲いの統計",
  "詰将棋等の学習の経過を見える化",
  "対局時計",
  "将棋AI対戦",
].join("。") + "などの機能があります"

// https://github.com/nuxt-community/sitemap-module
// http://localhost:4000/sitemap.xml
const axios = require('axios')
const sitemap = {
  hostname: process.env.MY_NUXT_URL,
  gzip: true,
  cacheTime: (process.env.NODE_ENV === 'development' ? 0 : 1000 * 60 * 60), // 1時間
  exclude: [
    "/experiment/**",
    "/settings/**",
    "/launcher",
    "/inspire",
    "/rack/articles/new",
    "/rack/books/new",
  ],
  routes: async () => {
    let list = []
    let res = null

    // http://localhost:3000/api/wkbk/tops/sitemap
    res = await axios.get(`${process.env.API_URL}/api/wkbk/tops/sitemap`)
    list = list.concat(res.data.books.map(({key}) => `/rack/books/${key}`))
    list = list.concat(res.data.articles.map(({key}) => `/rack/articles/${key}`))

    // http://localhost:3000/api/tsl_user_all
    res = await axios.get(`${process.env.API_URL}/api/tsl_league_all`)
    list = list.concat(res.data.map(({generation}) => `/three-stage-leagues/${generation}`))

    // http://localhost:3000/api/tsl_league_all
    res = await axios.get(`${process.env.API_URL}/api/tsl_user_all`)
    list = list.concat(res.data.map(({name}) => `/three-stage-league-players/${name}`))

    list.push("/swars/histograms/attack")
    list.push("/swars/histograms/defense")
    list.push("/swars/histograms/technique")
    list.push("/swars/histograms/note")

    return list
  },
}

const config = {
// export default {
  // debug: true,

  // https://ja.nuxtjs.org/guides/configuration-glossary/configuration-ssr/
  //
  //   mode は DEPRECATED なので下に置き換え
  //
  //   mode: 'spa'        → ssr: false
  //   mode: 'universal'  → ssr: true
  //
  ssr: true,

  /*
  ** Nuxt target
  ** See https://nuxtjs.org/api/configuration-target
  */
  target: 'server', // なにこれ？

  router: {
    // https://ja.nuxtjs.org/docs/2.x/configuration-glossary/configuration-router/#linkactiveclass
    linkActiveClass: 'is-active',

    // base: process.env.NODE_ENV === 'production' ? "/app/" : "/",

    // https://ja.nuxtjs.org/api/configuration-router/#trailingslash
    // trailingSlash: false,
  },

  generate: {
    subFolders: false,  // false: xxx.html true: xxx/index.html
    // dir: '../public', Railsの / を直接置き換える
  },

  /*
  ** Headers of the page
  */
  head: {
    title: "?",
    titleTemplate: `%s - ${process.env.APP_NAME}`,
    // titleTemplate(title) {
    //   return (title ? `${title} - ` : "") + process.env.APP_NAME
    // },

    htmlAttrs: {
      lang: "ja",
      prefix: 'og: http://ogp.me/ns#',
      class: `NODE_ENV-${process.env.NODE_ENV} STAGE-${process.env.STAGE}`,
    },
    meta: [
      // https://ja.nuxtjs.org/faq/duplicated-meta-tags/
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: SITE_DESC },
      { name: "action-cable-url", content: (process.env.NODE_ENV === 'development' ? process.env.MY_SITE_URL : "") + "/maincable" },

      // 「ホーム画面に追加」したあとアプリのような画面にする設定
      //
      //  ・画面は広くなる
      //  ・が、iOS では localStorage がWEBと繋がっていない問題があったりなかったりする
      //  ・ブラウザで使えた便利機能が一切使えなくなって困惑
      //  ・何があっても他に遷移しない閉じたWEBサービスでしか使えない
      //  ・のでいったんやめ
      //
      //   https://qiita.com/amishiro/items/e668be423a85c2b61696
      //   https://pwa.nuxtjs.org/meta#mobileappios
      //   https://developer.apple.com/library/archive/documentation/AppleApplications/Reference/SafariHTMLRef/Articles/MetaTags.html
      //   https://medium.com/@firt/dont-use-ios-web-app-meta-tag-irresponsibly-in-your-progressive-web-apps-85d70f4438cb
      //
      // { name: 'apple-mobile-web-app-capable',          content: 'yes'               },
      // { name: 'apple-mobile-web-app-status-bar-style', content: 'black-translucent' },

      ////////////////////////////////////////////////////////////////////////////////
      { hid: "og:site_name",   property: "og:site_name",   content: process.env.APP_NAME },
      { hid: "og:type",        property: "og:type",        content: "website" },
      { hid: "og:url",         property: "og:url",         content: process.env.MY_SITE_URL }, // これいるのか？

      // 重要なのはこの4つだけで各ページで上書きする
      { hid: "og:title",       property: "og:title",       content: process.env.APP_NAME },
      { hid: "og:description", property: "og:description", content: SITE_DESC },
      { hid: "og:image",       property: "og:image",       content: process.env.MY_NUXT_URL + "/ogp/application.png" },
      { hid: "twitter:card",   property: "twitter:card",   content: "summary_large_image" }, // summary or summary_large_image

      { hid: "twitter:site",       property: "twitter:site",       content: "@sgkinakomochi" }, // これいるのか？
      { hid: "twitter:creator",    property: "twitter:creator",    content: "@sgkinakomochi" }, // これいるのか？

    ],
    // script: [
    //   { src: "https://twemoji.maxcdn.com/v/latest/twemoji.min.js", crossorigin: "anonymous", },
    // ],
    link: [
      { hid: "icon",             rel: 'icon', type: 'image/x-icon', href: '/favicon.ico'          },
      { hid: "apple-touch-icon", rel: "apple-touch-icon",           href: "/apple-touch-icon.png" },
    ],
    // base: { href: process.env.MY_SITE_URL },
  },
  /*
  ** Customize the progress-bar color
  */
  // loading: { color: 'hsl(348, 100%, 61%)' }, // bulma red color
  // loading: { color: 'hsl(48,  100%, 67%)' }, // bulma yellow color
  loading: { color: 'hsl(0, 0%, 21%)' }, // bulma grey-daker color
  /*
  ** Global CSS
  */
  css: [
    // 'application.sass'
    // '~/assets/css/buefy.scss',
    // '~/assets/sass/application.sass',
    // '../app/javascript/stylesheets/application.sass',
    './assets/sass/application.sass',
    // '@/assets/custom-styles.scss'
  ],
  styleResources: {
    sass: [
      './assets/sass/styleResources.scss', // sass の項目に scss のファイルを与えないと読み込まれないのは謎
    ],
    // scss: [
    //   // '~assets/vars/*.scss',
    //   // '~assets/abstracts/_mixins.scss'
    // ]
  },

  /*
  ** Plugins to load before mounting the App
  */
  plugins: [
    // client only
    "~/plugins/mixin_mod.client.js",
    "~/plugins/chart_init.client.js",
    "~/plugins/local_storage_persistedstate.client.js",

    // 両方
    "~/plugins/axios.js",
    "~/plugins/universal.js",
  ],
  /*
  ** Auto import components
  ** See https://nuxtjs.org/api/configuration-components
  */
  components: true,
  /*
  ** Nuxt.js dev-modules
  */
  buildModules: [
    // https://github.com/nuxt-community/analytics-module
    [
      '@nuxtjs/google-analytics',
      {
        id: 'UA-109851345-1',
        // // コメントアウトすると開発環境で確認できる
        // debug: {
        //   enabled: true,
        //   sendHitTask: true,
        // },
      },
    ],
  ],
  /*
  ** Nuxt.js modules
  */
  modules: [
    // Doc: https://buefy.github.io/#/documentation
    // ~/src/shogi-extend/front_app/node_modules/nuxt-buefy/lib/module.js
    [
      'nuxt-buefy',
      {
        css: false,
        // materialDesignIconsHRef: '//cdn.materialdesignicons.com/5.0.45/css/materialdesignicons.min.css',
        materialDesignIconsHRef: "https://cdn.jsdelivr.net/npm/@mdi/font@5.x/css/materialdesignicons.min.css",

        // ~/src/shogi-extend/front_app/node_modules/buefy/src/utils/config.js
        defaultTooltipType: "is-dark",
        defaultTooltipDelay: 20,
      }
    ],
    // Doc: https://axios.nuxtjs.org/usage
    '@nuxtjs/axios',
    '@nuxtjs/proxy',

    // https://pwa.nuxtjs.org/
    // '@nuxtjs/onesignal',   // push通知
    // '@nuxtjs/pwa',         // アプリ化

    '@nuxtjs/style-resources',
    '@nuxtjs/sitemap',
  ],

  sitemap,

  /*
  ** Axios module configuration
  ** See https://axios.nuxtjs.org/options
  */
  axios: {
    debug: process.env.NODE_ENV === 'development',
    // proxy: process.env.NODE_ENV === 'development',

    // baseURL の設定があれば、何を実行しても 3000 の方に行くので /api は 3000 のような proxy を設定する必要はないっぽい
    // baseURL: process.env.MY_SITE_URL, // generate する staging では proxy が無効になり https://shogi-flow.xyz/api/* を叩かせる
    // これ↓をみると API_URL が定義されていれば baseURL に勝つらしい
    // https://github.com/nuxt-community/axios-module/blob/master/lib/module.js

    headers: {
      "Content-Type": "application/json", // ← これがあるとAPIを叩くときいちいち .json をつけなくてよくなる
      // "X-Requested-With": "XMLHttpRequest", // ←これがあると $axios.$get("https://yesno.wtf/api") が動かない
    },
    // responseType: "json",

    credentials: true,             // これを入れないと /api/talk のとき HTML が返ってきてしまう(？)
  },

  // 下で設定している
  proxy: {},

  /*
  ** Build configuration
  */
  // オーディオファイルをロードするように Webpack の設定を拡張するには？
  // https://ja.nuxtjs.org/faq/webpack-audio-files
  build: {
    // https://ja.nuxtjs.org/api/configuration-build#extractcss
    extractCSS: process.env.NODE_ENV === "production", // htmlファイルにスタイルが吐かれるのを防ぐ。trueにするとHMRが効かないので注意

    // TODO: 意味を調べる
    optimization: {
      splitChunks: {
        cacheGroups: {
          styles: {
            name: 'styles',
            test: /\.(scss|sass|css|vue)$/,
            chunks: 'all',
            enforce: true,
          },
        },
      },
    },

    // https://ja.nuxtjs.org/api/configuration-build/#transpile
    transpile: ["shogi-player/components"], // 外側にあるファイルは import 文を require に変換しないと node でパースできない

    // オーディオファイルをロードするように Webpack の設定を拡張するには？
    // https://ja.nuxtjs.org/faq/webpack-audio-files/
    //
    //   <audio :src="require('@/assets/water.mp3')" controls></audio>
    //   <audio src="@/assets/water.mp3" controls></audio>
    //
    loaders: {
      vue: {
        transformAssetUrls: {
          audio: 'src'
        }
      }
    },

    extend (config, ctx) {
      config.module.rules.push({
        test: /\.(ogg|mp3|wav|mpe?g)$/i,
        loader: 'file-loader',
        options: {
          name: '[path][name].[ext]'
        },
      })
      config.module.rules.push({
        test: /\.(txt|md|kif|ki2|csa|sfen)$/,
        loader: 'raw-loader',
        // exclude: /(node_modules)/,
      })
    },
  },

  // https://nuxtjs.org/guide/runtime-config
  // 空文字列は空で設定したのではなく XXX: process.env.XXX の意味(わかりにくすぎ)
  // またビルドしてもこの情報はそこに含まれてないので注意
  // デプロイするときには .nuxt だけでなく .env* も転送しないといけない
  // このせいで本番環境なのに開発環境の設定で運用していて不可解な現象が起きていた
  publicRuntimeConfig: {
    CSR_BUILD_VERSION: BUILD_VERSION,
    MY_SITE_URL: "",
    MY_NUXT_URL: "",
    STAGE: "",
    APP_NAME: "",
  },

  // SSR側での定義で publicRuntimeConfig を上書きする
  // 意味はよくわかっていない
  privateRuntimeConfig: {
    SSR_BUILD_VERSION: BUILD_VERSION,
  },

  // 面倒な process.env.XXX の再定義
  // ・ここで定義すると .vue 側で process.env.XXX で参照できる
  // ・しかし process.env.XXX は文字列として展開されるので非常に扱いづらい
  // ・それを忘れて process.env がハッシュだと勘違いしていつもはまる
  // ・だから publicRuntimeConfig を使う方がよい
  // ・ちなみに NUXT_ENV_ プレフィクスをつけた環境変数は自動的にここで定義したことになる
  // ・しかしプレフィクスはついたままなのでこれまた使いにくい
  // ・なので publicRuntimeConfig を使う方がよい
  env: {
    // FOO: process.env.FOO,
    ENV_BUILD_VERSION: BUILD_VERSION,
  },
}

// :src="/rails/..." のときに 3000 に切り替えるための仕組みであって axios はなんも関係ない
if (process.env.NODE_ENV === 'development') {
  // // これがないと CORS にひっかかる
  // // ↓これいらんはず
  // config.proxy["/api"]        = process.env.MY_SITE_URL

  // ↓これはいる(たぶん)
  config.proxy["/system"]     = process.env.MY_SITE_URL // for mp3
  config.proxy["/rails"]      = process.env.MY_SITE_URL // for /rails/active_storage/*
  config.proxy["/assets"]     = process.env.MY_SITE_URL // for /assets/human/0005_fallback_avatar_icon-f076233f605139a9b8991160e1d79e6760fe6743d157446f88b12d9dae5f0e03.png
  // config.proxy["/x.json"]     = process.env.MY_SITE_URL // for /x.json
  config.proxy["/admin"]     = process.env.MY_SITE_URL
}

export default config
