class AppEntryInfo
  include ApplicationMemoryRecord
  memory_record [
    {
      display_p: true,
      experiment_p: false,
      nuxt_link_to: { name: "swars-search" },
      title: "将棋ウォーズ棋譜検索",
      og_image_key: "swars-search",
      description: "他のアプリで検討したいときにどうぞ",
      features: [
        "ぴよ将棋や KENTO ですぐ開ける",
        "他のソフトにはコピーして張り付け (CTRL+V)",
        "プレイヤー戦力分析機能あり",
      ],
    },
    {
      display_p: true,
      experiment_p: false,
      nuxt_link_to: { path: "/share-board" },
      title: "共有将棋盤",
      attention_label: nil,
      og_image_key: %w[share-board-real],
      description: "ガチVS・仲間内リレー将棋・指導対局にどうぞ",
      features: [
        "チャット機能あり",
        "手合割や持ち時間を自由に設定可",
        "詰将棋の出題や棋譜の共有にもどうぞ",
      ],
    },
    {
      display_p: true,
      experiment_p: false,
      nuxt_link_to: { path: "/xy" },
      title: "符号の鬼",
      attention_label: nil,
      og_image_key: "xy",
      description: "脳内将棋マスター養成所",
      features: [
        "100問正解するまでの時間を競い合おう",
        "1分30秒切ったら卒業",
        "1分切ったら人間卒業",
      ],
    },
    {
      display_p: true,
      experiment_p: false,
      nuxt_link_to: { path: "/adapter" },
      title: "なんでも棋譜変換",
      og_image_key: "adapter",
      description: "棋譜形式の混沌に悩む方向け",
      features: [
        "変則的な棋譜を正規化する",
        "KENTOのURLや将棋クエストの棋譜をKIFに変換",
        "KIF・KI2・SFEN・BOD 形式の相互変換",
      ],
    },
    {
      key: :kiwi_lemon_new,
      display_p: !Rails.env.production? || true,
      experiment_p: false,
      nuxt_link_to: { path: "/video/new" },
      title: "動画作成",
      attention_label: nil,
      og_image_key: "video-new",
      description: "棋譜を動画にしたいときにどうぞ",
      features: [
        "mp4, gif, png, zip 等に変換",
        "「なんでも棋譜変換」とかぶってるけどこっちは時間のかかる変換に特化している",
      ],
    },
    {
      key: :kiwi_lemon_index,
      display_p: !Rails.env.production? || true,
      experiment_p: false,
      nuxt_link_to: { path: "/video" },
      title: "動画ライブラリ",
      attention_label: nil,
      og_image_key: "video",
      description: "動画作成のあとで登録するとここで見れる",
      features: [
        "こんなところより YouTube に上げよう",
      ],
    },
    {
      key: :wkbk,
      display_p: true,
      experiment_p: false,
      nuxt_link_to: { path: "/rack" },
      title: "将棋ドリル",
      attention_label: nil,
      og_image_key: "rack",
      description: "自分専用の問題集を作りたいときにどうぞ",
      features: [
        "本人が本人のために作る問題集エディタ",
        "「問題」を作って「問題集」に入れるだけ",
        "YouTube と似たような公開設定機能あり",
      ],
    },
    {
      display_p: true,
      experiment_p: false,
      nuxt_link_to: { path: "/stopwatch" },
      title: "詰将棋用ストップウォッチ",
      og_image_key: "stopwatch",
      description: "正解率や速度を見える化したいときにどうぞ",
      features: [
        "間違えた問題だけの復習が簡単",
        "途中からの再開が簡単",
        "問題は自分で用意しよう",
      ],
    },

    ################################################################################

    {
      display_p: true,
      experiment_p: false,
      nuxt_link_to: { path: "/lab/swars/standard-score" },
      title: "将棋ウォーズ偏差値",
      og_image_key: "quick_script/swars/standard_score_script",
      description: "自分の偏差値を知りたいときにどうぞ",
      features: [
        "一日ごと更新",
        "本気で取り組んでいる棋力帯の山を対象とする",
      ],
    },

    {
      display_p: true,
      experiment_p: false,
      nuxt_link_to: { path: "/lab/swars/tactic-list" },
      title: "戦法一覧",
      og_image_key: "quick_script/swars/tactic_list_script",
      description: "戦法・囲い・手筋などの一覧",
      features: [
        "レアな戦法の棋譜を探すのにおすすめ",
      ],
    },

    {
      display_p: true,
      experiment_p: false,
      nuxt_link_to: { path: "/lab/swars/tactic-stat" },
      title: "将棋ウォーズ戦法勝率ランキング",
      og_image_key: "quick_script/swars/tactic_stat_script",
      description: "最近のいちばん強い戦法がわかる",
      features: [
        "一日ごと更新",
        # "勝率の高い「囲い」も見れる",
        # "人気戦法の対策をすれば勝ちやすいかも？",
      ],
    },

    {
      display_p: true,
      experiment_p: false,
      nuxt_link_to: { path: "/lab/swars/cross-search" },
      title: "横断棋譜検索",
      og_image_key: "quick_script/swars/cross_search_script",
      description: "複雑な条件で検索したいときにどうぞ",
      # features: [
      #   "変動するように最近のだけ出してる",
      #   "戦法や囲いの分布もある",
      #   "人気戦法の対策をすれば勝ちやすいかも？",
      # ],
    },

    {
      display_p: false,
      experiment_p: false,
      nuxt_link_to: { path: "/lab/general/encyclopedia" },
      title: "戦法ミニ事典",
      og_image_key: "quick_script/general/encyclopedia_script",
      description: "戦法の組み方を知りたいときにどうぞ",
      # features: [
      #   "変動するように最近のだけ出してる",
      #   "戦法や囲いの分布もある",
      #   "人気戦法の対策をすれば勝ちやすいかも？",
      # ],
    },

    ################################################################################

    {
      display_p: true,
      experiment_p: false,
      nuxt_link_to: { path: "/three-stage-leagues" },
      title: "奨励会三段リーグ成績早見表",
      og_image_key: "three-stage-league",
      description: "個人成績を見たいときにどうぞ",
      features: [
        # "スマホに最適化",
        # "個人毎の総成績表示",
        # "在籍期間の表示",
      ],
    },
    {
      display_p: true,
      experiment_p: false,
      nuxt_link_to: { path: "/vs-clock" },
      title: "対局時計",
      attention_label: nil,
      og_image_key: "vs-clock",
      description: "大会などで時計が足りないときにどうぞ",
      features: [
        "一般的なネット対局のプリセットを用意",
        "将棋倶楽部24の猶予時間に対応",
        "フィッシャールール対応",
      ],
    },
    {
      display_p: true,
      experiment_p: false,
      nuxt_link_to: { path: "/cpu-battle" },
      title: "CPU対戦",
      og_image_key: "cpu-battle",
      description: "ネット将棋で心をやられたときにどうぞ",
      features: [
        "自作の将棋AI",
        "見掛け倒しな戦法を指す",
        "作者に似て弱い",
      ],
    },
    {
      display_p: false, # !Rails.env.production?,
      experiment_p: false,
      nuxt_link_to: { path: "/vs" },
      title: "対人戦",
      attention_label: nil,
      og_image_key: "share-board-vs",
      description: "気軽に対局したいときにどうぞ",
      features: [
        "プレイ人数 1〜8人",
        "いまのところはログイン不要",
        "これは共有将棋盤の「自動ﾏｯﾁﾝｸﾞ」へのｼｮｰﾄｶｯﾄです",
      ],
    },
    {
      display_p: true,
      experiment_p: false,
      nuxt_link_to: { path: "/lab" },
      title: "実験室",
      og_image_key: "lab",
      description: nil,
      features: [
      ],
    },
    {
      key: :gallery,
      display_p: true,
      experiment_p: false,
      nuxt_link_to: { path: "/gallery" },
      title: "将棋盤テクスチャ集",
      attention_label: nil,
      og_image_key: "gallery",
      description: "将棋盤用の木をどうぞ",
      features: [
        "木目3種類 × 濃淡4種類",
        "サイズ: 1080x1080",
        "色合いは使用する駒に合わせて調整しよう",
      ],
    },
    {
      display_p: true,
      experiment_p: false,
      nuxt_link_to: { path: "/style-editor" },
      title: "将棋盤スタイルエディタ",
      attention_label: nil,
      og_image_key: "style-editor",
      description: "将棋盤のスタイルをいじくる開発用ツール",
      features: [
        "将棋盤の動作テスト用に作ったもの",
        "他の用途にも使えそうなので公開している",
      ],
    },
  ]

  def og_image_key
    Array.wrap(super).sample
  end

  def og_meta
    [:title, :description, :og_image_key].inject({}) { |a, e| a.merge(e => public_send(e)) }
  end
end
