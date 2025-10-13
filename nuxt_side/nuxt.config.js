import dayjs from "dayjs"
// import QueryString from "query-string"

const BUILD_VERSION = dayjs().format("YYYY-MM-DD HH:mm:ss")
const PRODUCTION_P = process.env.NODE_ENV === "production"
const DEVELOPMENT_P = !PRODUCTION_P

console.log("BASIC_AUTH_USERNAME")
console.log(process.env.BASIC_AUTH_USERNAME)
console.log("BASIC_AUTH_PASSWORD")
console.log(process.env.BASIC_AUTH_PASSWORD)

const SITE_DESC = "将棋のいろんなツールを提供するサイト。" + [
  "将棋ウォーズ棋譜検索・統計",
  "リレー将棋・ネット対戦・詰将棋作成",
  "符号練習",
  "問題集作成",
  "棋譜の相互変換",
  "棋譜の動画化",
  "三段リーグ早見表",
  "詰将棋問題用ストップウォッチ",
  "対局時計",
  "将棋AI対戦",
  "将棋盤画像",
].join("・") + "などがあります"

// https://github.com/nuxt-community/sitemap-module
// http://localhost:4000/sitemap.xml
const axios = require("axios")
const sitemap = {
  hostname: process.env.MY_NUXT_URL,
  gzip: true,
  cacheTime: (DEVELOPMENT_P ? 0 : 1000 * 60 * 60), // 1時間
  exclude: [
    "/experiment/**",
    "/launcher",
    "/inspire",
    "/rack/articles/new",
    "/rack/books/new",
    "/video/studio/**",
  ],
  routes: async () => {
    let list = []
    let res = null

    // http://localhost:3000/api/lab/chore/sitemap.json
    res = await axios.get(`${process.env.API_URL}/api/lab/chore/sitemap.json`)
    list = list.concat(res.data.body)

    // http://localhost:3000/api/kiwi/tops/sitemap
    res = await axios.get(`${process.env.API_URL}/api/kiwi/tops/sitemap`)
    list = list.concat(res.data.bananas.map(({key}) => `/video/watch/${key}`))

    // http://localhost:3000/api/wkbk/tops/sitemap
    res = await axios.get(`${process.env.API_URL}/api/wkbk/tops/sitemap`)
    list = list.concat(res.data.books.map(({key}) => `/rack/books/${key}`))
    list = list.concat(res.data.articles.map(({key}) => `/rack/articles/${key}`))

    return list
  },
}

const config = {
// export default {
  // debug: true,

  // Nuxt の target と mode と ssr と各 npm コマンドについて
  // https://zenn.dev/kurosame/articles/52e96b724380d2

  // https://ja.nuxtjs.org/guides/configuration-glossary/configuration-ssr/
  //
  //   mode は DEPRECATED なので下に置き換え
  //
  //   mode: "spa"        → ssr: false
  //   mode: "universal"  → ssr: true
  //
  ssr: true,

  /*
  ** Nuxt target
  ** See https://nuxtjs.org/api/configuration-target
  */
  target: "server", // なにこれ？

  router: {
    // // ↓ぜんぜん効いてない
    // extendRoutes(routes) {
    //   routes.push({
    //     path: '/lab/dev',
    //     fetchOnServer: false, // /lab/dev パスではクライアントサイドで fetch を実行する
    //   });
    // },

    // https://ja.nuxtjs.org/docs/2.x/configuration-glossary/configuration-router/#linkactiveclass
    // これを付けると非常にやっかいで自分ページに飛ぶ画面内のリンクすべて is-active 状態の色になってしまったりして、
    // さらにこれが強すぎて is-active を無効化するのがむつかしい
    // だからそもそも指定しない方がいい
    // linkActiveClass: "is-active",

    // クエリ文字列のパース方法をカスタマイズ
    // https://v2.nuxt.com/ja/docs/configuration-glossary/configuration-router/#parsequery--stringifyquery
    // デフォルトのままだと Rails が渡した "foo[]=1" を {"foo[]" => [1]} としてしまう。{foo: [1]} としないといけない。
    // https://zenn.dev/dl10yr/articles/nuxt3-stringifyquery
    //
    // ↓ QueryString が参照できない
    //
    // parseQuery: (query) => {
    //   if (process.env.NODE_ENV === "production") {
    //   } else {
    //     console.log("NUXT_CONFIG_JS")
    //     console.log(query)
    //     console.log(QueryString.parse(query, {arrayFormat: "bracket"}))
    //   }
    //   return QueryString.parse(query, {arrayFormat: "bracket"})
    // },
    // // // クエリパラメータのシリアライズ方法をカスタマイズ
    // // stringifyQuery(params) {
    // //   const result = QueryString.stringify(params, { arrayFormat: 'bracket' });
    // //   return result ? `?${result}` : '';
    // // }

    // base: process.env.NODE_ENV === "production" ? "/app/" : "/",

    // 最後のスラッシュ問題
    //
    // https://knote.dev/post/2020-03-19/nuxt-trailing-slash/
    // https://ja.nuxtjs.org/api/configuration-router/#trailingslash
    //
    //   true   => かならず付ける。つけないと動かない。つまり /items/1 でテストしていたのが動かなくなる
    //   false  => つけない。けど items/_key/index.vue の構成の場合は結局 /items/xxx/ になる
    //   未設定 => どっちでもいい。ただし SEO に影響ある
    //
    // trailingSlash: false,
  },

  generate: {
    subFolders: false,  // false: xxx.html true: xxx/index.html
    // dir: "../public", Railsの / を直接置き換える
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
      prefix: "og: http://ogp.me/ns#",
      class: `NODE_ENV-${process.env.NODE_ENV} STAGE-${process.env.STAGE}`,
    },
    meta: [
      // https://ja.nuxtjs.org/faq/duplicated-meta-tags/
      { charset: "utf-8" },

      // iOS で input の focus 時にズームインしてしまうのを viewport で解決する
      // https://zenn.dev/rhirayamaaan/articles/f0209ad6574ed4
      // { name: "viewport", content: "width=device-width, initial-scale=1.0" },
      { name: "viewport", content: "width=device-width, initial-scale=1.0, maximum-scale=1.0" },
      // { name: "viewport", content: "width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" },

      { hid: "description", name: "description", content: SITE_DESC },
      { name: "action-cable-url", content: (DEVELOPMENT_P ? process.env.MY_SITE_URL : "") + "/maincable" },

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
      { hid: "apple-mobile-web-app-capable", name: "apple-mobile-web-app-capable", content: "no" }, // ←初期値。上書きするとき name の指定がないと name が消える
      // { name: "apple-mobile-web-app-status-bar-style", content: "black-translucent" }, // ← とっくに無効

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
      { hid: "icon",             rel: "icon", type: "image/x-icon", href: "/favicon.ico"          },
      { hid: "apple-touch-icon", rel: "apple-touch-icon",           href: "/apple-touch-icon.png" },
    ],
    // base: { href: process.env.MY_SITE_URL },
  },
  /*
  ** Global CSS
  */
  css: [
    // "application.sass"
    // "~/assets/css/buefy.scss",
    // "~/assets/sass/application.sass",
    // "../app/javascript/stylesheets/application.sass",
    "./assets/sass/application.sass",
    // "@/assets/custom-styles.scss"
  ],

  // これを有効する面倒な方法
  // 1. yarn add --dev @nuxtjs/style-resources
  // 2. modules に "@nuxtjs/style-resources" を追加
  styleResources: {
    sass: [
      "./assets/sass/styleResources.sass", // sass の項目に scss のファイルを与えないと読み込まれない罠
    ],
    // scss: [
    //   // "~assets/vars/*.scss",
    //   // "~assets/abstracts/_mixins.scss"
    // ]
  },

  /*
  ** Plugins to load before mounting the App
  */
  plugins: [
    // 順番重要
    { src: "~/plugins/axios_loading.js",                   },
    { src: "~/plugins/axios_error_handler.js",             },
    // ここからは重要ではない
    { src: "~/plugins/my_common_plugin.js",                },
    { src: "~/plugins/my_common_mixin.js",                 },
    { src: "~/plugins/my_client_plugin.js", mode: "client" },
    { src: "~/plugins/my_client_mixin.js",  mode: "client" },
    { src: "~/plugins/my_chart_init.js",    mode: "client" },
    { src: "~/plugins/vue_history.js", mode: "client" },
  ],
  /*
  ** Auto import components
  ** See https://nuxtjs.org/api/configuration-components
  */
  // true はめちゃくちゃ使いにくい
  // components: true,
  components: [
    {
      path: "~/components",
      pathPrefix: false,
      extensions: ["vue"],      // vue で絞らないと js まで対象になって警告で埋め尽される
    },
  ],

  /*
  ** Nuxt.js dev-modules
  */
  buildModules: [
    // https://qiita.com/nakazawaken1/items/8f25ce58a27be092f7bc
    // yarn add --dev nuxt-vite
    // たしかに速いがまともにビルドできない
    // "nuxt-vite",
  ],
  /*
  ** Nuxt.js modules
  */
  modules: [
    [
      "@nuxtjs/google-gtag", {
        id: "G-GXD5LW1M1S",
        // config: {
        //   anonymize_ip: true,        // anonymize IP
        //   send_page_view: false,     // might be necessary to avoid duplicated page track on page reload
        //   linker: {
        //     domains: ["domain.com", "domain.org"],
        //   },
        // },
        // debug: true,                 // enable to track in dev mode
        // disableAutoPageTrack: false, // disable if you don"t want to track each page route with router.afterEach(...).
        additionalAccounts: [
          {
            id: "UA-109851345-1",        // required if you are adding additional accounts
            // config: {
            //   send_page_view: false, // optional configurations
            // },
          },
        ],
      },
    ],

    // Doc: https://buefy.github.io/#/documentation
    // ~/src/shogi-extend/nuxt_side/node_modules/nuxt-buefy/lib/module.js
    [
      "nuxt-buefy",
      {
        // ~/src/shogi-extend/nuxt_side/node_modules/nuxt-buefy/lib/module.js
        css: false,
        materialDesignIconsHRef: "//cdn.jsdelivr.net/npm/@mdi/font/css/materialdesignicons.min.css",
        async: false, // デフォルトの true のままだとアイコンがチラつく

        // ~/src/shogi-extend/nuxt_side/node_modules/buefy/src/utils/config.js
        defaultTooltipType: "is-dark",
        defaultTooltipDelay: 20,
      }
    ],

    // https://github.com/rigor789/vue-scrollTo
    [
      "vue-scrollto/nuxt",
      {
        duration: 0,
        // easing: "ease",
        // offset: 0,
        // force: true,
        // cancelable: true,
        // onStart: false,
        // onDone: false,
        // onCancel: false,
        // x: false,
        // y: true,
      },
    ],

    // Doc: https://axios.nuxtjs.org/usage
    "@nuxtjs/axios",
    "@nuxtjs/proxy",

    // https://pwa.nuxtjs.org/
    // "@nuxtjs/onesignal",   // push通知
    // "@nuxtjs/pwa",         // アプリ化

    "@nuxtjs/style-resources",  // これを書かないと styleResources が反応しない
    "@nuxtjs/sitemap",

    "nuxt-basic-auth-module", // BASIC認証
  ],

  // BASIC_認証
  basic: {
    name: process.env.BASIC_AUTH_USERNAME,
    pass: process.env.BASIC_AUTH_PASSWORD,
    enabled: true, // PRODUCTION_P,
    match: /^\/lab\/(dev|admin|secret|private|group1)(\/.*)?$/, // [REFS] BASIC_AUTH_MATCH
    // match: (req) => req.originalUrl === '/lab/dev',
  },

  sitemap,

  /*
  ** Axios module configuration
  ** See https://axios.nuxtjs.org/options
  */
  axios: {
    debug: DEVELOPMENT_P,
    // proxy: DEVELOPMENT_P,

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
    // Nuxt.jsのビルドを高速化してみる
    // https://tech.contracts.co.jp/entry/2020/12/14/161147
    // parallel: DEVELOPMENT_P,
    // cache: DEVELOPMENT_P,
    // hardSource: DEVELOPMENT_P,
    hardSource: DEVELOPMENT_P,

    // https://ja.nuxtjs.org/api/configuration-build#extractcss
    extractCSS: PRODUCTION_P, // htmlファイルにスタイルが吐かれるのを防ぐ。trueにするとHMRが効かないので注意

    // これは一体なんなんだ……？
    // https://qiita.com/soarflat/items/1b5aa7163c087a91877d
    optimization: {
      splitChunks: {
        cacheGroups: {
          styles: {
            name: "styles",
            test: /\.(scss|sass|css|vue)$/,
            chunks: "all",
            enforce: true,
          },
        },
      },
    },

    // https://ja.nuxtjs.org/api/configuration-build/#transpile
    transpile: [
      "shogi-player", // これを入れないとクラス変数や "??" 構文が読み取れない
      "marked",       // https://github.com/markedjs/marked/issues/2265#issuecomment-1754764288
    ],

    // オーディオファイルをロードするように Webpack の設定を拡張するには？
    // https://ja.nuxtjs.org/faq/webpack-audio-files/
    //
    //   <audio :src="require("@/assets/water.mp3")" controls></audio>
    //   <audio src="@/assets/water.mp3" controls></audio>
    //
    loaders: {
      vue: {
        transformAssetUrls: {
          audio: "src"
        }
      },

      // sass を使う
      //
      // ・node-sass と sass が一緒に入っていれば sass の方を使う
      // ・けど明示的に指定している
      // ・fibers は node16 以上では動かない
      // ・初回のビルドは node-sass より10倍ほど遅い
      // ・hardSource を有効にすると2度目はそれほど気にならないほど速い
      //
      // https://stackoverflow.com/a/57401587/9944769
      // https://v2.nuxt.com/docs/configuration-glossary/configuration-build/#loaders-sass-and-loaders-scss
      // https://www.suzunatsu.com/post/node-sass-to-dart-sass/
      sass: {
        // implementation: require("node-sass"),
        implementation: require("sass"),
        // sassOptions: {
        //   fiber: require("fibers"),
        // },
      },
      scss: {
        // implementation: require("node-sass"),
        implementation: require("sass"),
        // sassOptions: {
        //   // fiber: require("fibers"),
        // },
      },
    },

    // これを入れないと shogi-player で wav が読めない
    extend (config, ctx) {
      config.module.rules.push({
        test: /\.(ogg|mp3|mp4|m4a|wav|mpe?g)$/i,
        loader: "file-loader",
        options: {
          // name: "[path][name]-[contenthash].[ext]"
          name: "blob/[name]-[contenthash].[ext]",
          // require("path/to/xxx.wav") が { default: "/_nuxt/blob/xxx.wav", __esModule: true, ...} になってしまう対策
          // https://github.com/webpack-contrib/file-loader#esmodule
          // false にすると単にパス "/_nuxt/blob/xxx.wav" になる
          esModule: false,
        },
      })
      config.module.rules.push({
        test: /\.(txt|md|kif|ki2|csa|sfen)$/,
        loader: "raw-loader",
        // exclude: /(node_modules)/,
      })

      // // どこでエラーになったかわかりやすくする
      // // https://zenn.dev/shimiyu/scraps/80c150a0c68796
      // if (ctx.isDev) {
      //   config.devtool = ctx.isClient ? "source-map" : "inline-source-map"
      // }
    },

    babel: {
      plugins: [
        "@babel/plugin-proposal-logical-assignment-operators",
      ],
    },

    // babel: {
    //   // ↓よくわかっていない
    //   // 【Nuxt.js】新規作成時Babelで大量のWARNが出てくるときの解消法
    //   // https://qiita.com/hiroyukiwk/items/b283ef5312b289be6ce8
    //   plugins: [
    //     ["@babel/plugin-proposal-private-methods",            { loose: true }],
    //     ["@babel/plugin-proposal-private-property-in-object", { loose: true }],
    //   ],
    //
    //   // 【超注意】
    //   // テンプレートメソッドパターン動かなくなる原因はこれ
    //   // super 経由で呼ぶメソッドが親子を跨げなくなる
    //   //
    //   // presets({ isServer }, [preset, options]) {
    //   //   options.loose = true
    //   // },
    //
    //   // nuxt generateの際に「[BABEL] Note: The code generator has deoptimised the styling of」のメッセージ
    //   // https://qiita.com/someone7140/items/5acfc94c63f16115ac99
    //   compact: false,
    // },

    // 注意: なぜか ../.postcssrc.yml を見ているため

    // ↓これを書くとろくなことにならない
    // postcss: {
    //   postcssOptions: {
    //     // キーとしてプラグイン名を、値として引数を追加します
    //     // プラグインは前もって npm か yarn で dependencies としてインストールしておきます
    //     plugins: {
    //       // 値として false を渡すことによりプラグインを無効化します
    //       'postcss-url': false,
    //       // lost: true,
    //       // 'postcss-nested': false,
    //       // 'postcss-responsive-type': false,
    //       // 'postcss-hexrgba': false,
    //     },
    //   },
    //   preset: {
    //     // postcss-preset-env 設定を変更します
    //     autoprefixer: {
    //       grid: false,
    //     },
    //   },
    // },

    // https://github.com/webpack-contrib/postcss-loader/issues/405
    postcss: null,
  },

  // https://nuxtjs.org/guide/runtime-config
  // 空文字列は空で設定したのではなく XXX: process.env.XXX の意味(わかりにくすぎ)
  // またビルドしてもこの情報はそこに含まれてないので注意
  // デプロイするときには .nuxt だけでなく .env* も転送しないといけない
  // このせいで本番環境なのに開発環境の設定で運用していて不可解な現象が起きていた
  publicRuntimeConfig: {
    CSR_BUILD_VERSION: BUILD_VERSION,
    APP_NAME: "",
    STAGE: "",
    MY_SITE_URL: "",
    MY_NUXT_URL: "",
    MATERIAL_DIR_PREFIX: "",
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

////////////////////////////////////////////////////////////////////////////////// プログレスバー
//
// https://v2.nuxt.com/ja/docs/features/loading/
//
// config.loading = { color: "hsl(348, 100%, 61%)" }, // bulma red color
// config.loading = { color: "hsl(48,  100%, 67%)" }, // bulma yellow color
// config.loading = { color: "hsl(0, 0%, 21%)"     }, // bulma grey-daker color
// config.loading = { color: "orange", height: "8px"  }, // bulma cyan
//
if (DEVELOPMENT_P) {
  // 挙動がよくわからんのでいろいろ試してよかったのだけ production に適用する
  config.loading = {
    color: "hsl(204, 86%, 53%)",        // bulma cyan color // プログレスバーの CSS カラー
    failedColor: "hsl(348, 100%, 61%)", // bulma red color  // ルートをレンダリング中にエラーが発生した場合のプログレスバーの CSS カラー
    height: "8px",                      // 高さ
    throttle: 0,                        // プログレスバーを表示するまでに待つ時間(ms)。プログレスバーの点滅を防ぐことに役立つ。
    duration: 5000,                     // プログレスバーを表示する時間の最大値（ms）
    continuous: true,                   // ローディングが duration で指定した時間より長くかかる場合にアニメーションを継続する。
  }
} else {
  config.loading = {
    color: "hsl(204, 86%, 53%)",        // bulma cyan color // プログレスバーの CSS カラー
    failedColor: "hsl(348, 100%, 61%)", // bulma red color  // ルートをレンダリング中にエラーが発生した場合のプログレスバーの CSS カラー。（例えば data または fetch がエラーを返したとき）
  }
}

// :src="/rails/..." のときに 3000 に切り替えるための仕組みであって axios はなんも関係ない
if (DEVELOPMENT_P) {
  // // これがないと CORS にひっかかる
  // // ↓これいらんはず
  // config.proxy["/api"]        = process.env.MY_SITE_URL

  // ↓たぶんこれはいる
  config.proxy["/system"]          = process.env.MY_SITE_URL // for mp3
  config.proxy["/rails"]           = process.env.MY_SITE_URL // for /rails/active_storage/*
  config.proxy["/assets"]          = process.env.MY_SITE_URL // for /assets/human/0005_fallback.png
  // config.proxy["/x.json"]       = process.env.MY_SITE_URL // for /x.json
  config.proxy["/admin"]           = process.env.MY_SITE_URL
  config.proxy["/animation-files"] = process.env.MY_SITE_URL
  // config.proxy["/u"             = process.env.MY_SITE_URL // これを入れると /users/1 が Rails 側に飛んでしまう
}

export default config
