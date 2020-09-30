import dayjs from "dayjs"
const BUILD_VERSION = dayjs().format("YYYY-MM-DD HH:mm:ss")

const config = {
// export default {
  // debug: true,

  // mode: 'spa',
  mode: 'universal',

  /*
  ** Nuxt target
  ** See https://nuxtjs.org/api/configuration-target
  */
  target: 'server',

  router: {
    base: process.env.NODE_ENV === 'production' ? "/app/" : "/",
  },

  generate: {
    subFolders: false,  // false: xxx.html true: xxx/index.html
    // dir: '../public', Railsの / を直接置き換える
  },

  /*
  ** Headers of the page
  */
  head: {
    title: "TOP",
    titleTemplate: `%s - SHOGI-EXTEND`,
    htmlAttrs: {
      lang: "ja",
      prefix: 'og: http://ogp.me/ns#',
      class: process.env.NODE_ENV,
    },
    meta: [
      // https://ja.nuxtjs.org/faq/duplicated-meta-tags/
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: "将棋に関連する便利サービスを提供するサイトです" },
      { name: "action-cable-url", content: (process.env.NODE_ENV === 'development' ? "http://0.0.0.0:3000" : "") + "/x-cable" },

      { hid: "og:site_name",   property: "og:site_name",   content: "SHOGI-EXTEND" },
      { hid: "og:type",        property: "og:type",        content: "website" },
      { hid: "og:url",         property: "og:url",         content: process.env.MY_SITE_URL }, // これいるのか？

      // 重要なのはこの4つだけで各ページで上書きする
      { hid: "og:title",       property: "og:title",       content: "SHOGI-EXTEND" },
      { hid: "og:description", property: "og:description", content: "将棋に関連する便利サービスを提供するサイトです" },
      { hid: "og:image",       property: "og:image",       content: process.env.MY_OGP_URL + "/ogp/application.png" },
      { hid: "twitter:card",   property: "twitter:card",   content: "summary" }, // summary or summary_large_image

      { hid: "twitter:site",       property: "twitter:site",       content: "@sgkinakomochi" }, // これいるのか？
      { hid: "twitter:creator",    property: "twitter:creator",    content: "@sgkinakomochi" }, // これいるのか？

    ],
    link: [
      { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }
    ],
    // base: { href: "http://0.0.0.0:3000" },
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
    // '../app/javascript/stylesheets/bulma_init.scss',
    // '~/assets/css/buefy.scss',
    // '~/assets/sass/application.sass',
    // '../app/javascript/stylesheets/application.sass',
    './assets/sass/application.sass',
    // '@/assets/custom-styles.scss'
  ],
  styleResources: {
    sass: [
      './assets/sass/resource.scss', // FIXME: なぜか sass の項目に *.scss のファイルを与えないと読み込まれない
    ],
    // scss: [
    //   // "../app/javascript/stylesheets/bulma_init.scss",
    //   // '~assets/vars/*.scss',
    //   // '~assets/abstracts/_mixins.scss'
    // ]
  },

  /*
  ** Plugins to load before mounting the App
  */
  plugins: [
    "~/plugins/mixin_mod.client.js",
    "~/plugins/other.client.js",
    "~/plugins/axios_mod.js",
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
    ['@nuxtjs/google-analytics', { id: 'UA-109851345-1' }],
  ],
  /*
  ** Nuxt.js modules
  */
  modules: [
    // Doc: https://buefy.github.io/#/documentation
    ['nuxt-buefy', {css: false}],
    // Doc: https://axios.nuxtjs.org/usage
    '@nuxtjs/axios',
    '@nuxtjs/proxy',
    '@nuxtjs/pwa',
    '@nuxtjs/style-resources',
  ],
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
    transpile: ["shogi-player"], // 外側にあるファイルは import 文を require に変換しないと node でパースできない

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
    },
  },

  // https://nuxtjs.org/guide/runtime-config
  // 空文字列は空で設定したのではなく XXX: process.env.XXX の意味(この仕様は余計にわかりにくい)
  publicRuntimeConfig: {
    CSR_BUILD_VERSION: BUILD_VERSION,
    MY_SITE_URL: "",
    MY_OGP_URL: "",
  },

  // SSR側での定義で publicRuntimeConfig を上書きする
  privateRuntimeConfig: {
    SSR_BUILD_VERSION: BUILD_VERSION,
  },

  // 面倒な process.env.XXX の再定義
  // ・ここで定義すると .vue 側で process.env.XXX で参照できる
  // ・が、だとテンプレートで使えなかったり単なる文字列だったり process.env が空だったりでデバッグしにくい
  // ・ので publicRuntimeConfig を使う方がよい
  // ・NUXT_ENV_ プレフィクスをつけた環境変数は自動的にここで定義したことになる(プレフィクスはついたまま)
  // ・だけど publicRuntimeConfig を使う方がまし
  env: {
    // FOO: process.env.FOO,
    ENV_BUILD_VERSION: BUILD_VERSION,
  },
}

// :src="/rails/..." のときに 3000 に切り替えるための仕組みであって axios はなんも関係ない
if (process.env.NODE_ENV === 'development') {
  // // これがないと CORS にひっかかる
  // // ↓これいらんはず
  // config.proxy["/api"]        = "http://0.0.0.0:3000"

  // ↓これはいる(たぶん)
  config.proxy["/system"]     = "http://0.0.0.0:3000" // for mp3
  config.proxy["/rails"]      = "http://0.0.0.0:3000" // for /rails/active_storage/*
  config.proxy["/assets"]     = "http://0.0.0.0:3000" // for /assets/human/0005_fallback_avatar_icon-f076233f605139a9b8991160e1d79e6760fe6743d157446f88b12d9dae5f0e03.png
  // config.proxy["/x.json"]     = "http://0.0.0.0:3000" // for /x.json
  config.proxy["/admin"]     = "http://0.0.0.0:3000"
}

export default config
