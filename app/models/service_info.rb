class ServiceInfo
  include ApplicationMemoryRecord
  memory_record [
    {
      display_p: true,
      link_path: [:swars, :battles],
      icon: "magnify",
      title: "将棋ウォーズ棋譜検索",
      image_source: "swars_battles_index.png",
      description: "直近の対局の検討することを目的とした棋譜取得サービスで次のような機能があります",
      feature_items: [
        "「ぴよ将棋」や「KENTO」とのスムーズな連携",
        "棋譜をクリップボードにコピー(激指やShogiGUIに渡せる)",
        "消費時間の可視化",
        "棋譜用紙化(印刷可)",
        "指定局面の画像化やツイート",
        "段級位毎や戦法毎の勝率確認",
      ],
    },
    {
      display_p: true,
      link_path: [:adapter],
      icon: "tools",
      title: "なんでも棋譜変換",
      image_source: "adapter.png",
      description: "互換性が低い棋譜形式を一般的な形式に変換や補正してどのソフトでも読めるようにするのが目的のサービスで次のような特徴があります",
      feature_items: [
        "変則的な「将棋倶楽部24」の棋譜を正規化",
        "「将棋クエスト」のCSA形式の棋譜をKIF形式に変換",
        "「ぴよ将棋」や「KENTO」に橋渡し",
        "棋譜をネットで公開する(ツイート機能あり)",
        "KIF・KIF・SFEN・BOD 形式の相互変換",
        "特定局面の画像化",
        "棋譜情報を含む「将棋DB2」や「KENTO」のURLから棋譜形式に復元",
      ],
    },
    {
      display_p: true,
      link_path: [:share_board],
      icon: "apps",
      title: "共有将棋盤",
      image_source: "share_board_1200x630.png",
      description: "リレー将棋・詰将棋の出題・課題局面を共有しての検討などを目的とした将棋盤の共有サービスで次のような特徴があります",
      feature_items: [
        "盤面編集で課題局面や詰将棋の作成ができる",
        "URLをTwitter等のSNSに貼ると局面画像が現れる",
        "URLから訪れた人は指し継ぐことができる(駒を動かしながら解くことができる)",
        "棋譜や視点の情報はすべてURLに含まれている",
        "そのため分岐しても前の状態に影響を与えない",
      ],
    },
    {
      display_p: true,
      link_path: [:xy_records],
      icon: "apps",
      title: "符号の鬼",
      image_source: "xy_records_1200x630.png",
      description: "符号を覚えるためのミニゲームで次のような特徴があります",
      feature_items: [
        "画面をタップする携帯用とキーボードで入力するPC用の2つのモード",
        "100問正解するまでの時間を競う",
        "先手と後手の両方の視点で練習可",
        "ランキングあり",
      ],
    },
    {
      display_p: true,
      link_path: [:cpu_battles],
      icon: "robot",
      title: "CPU対戦",
      image_source: "cpu_battle_1200x630.png",
      description: "自作の将棋AIと対局できます。CPUは矢倉・右四間飛車・嬉野流・アヒル戦法・振り飛車・英春流かまいたち戦法を指せます",
    },
    {
      display_p: true,
      link_path: [:stopwatch],
      icon: "clock",
      title: "詰将棋RTA用ストップウォッチ",
      image_source: "stopwatch_1200x630.png",
      description: "詰将棋などの問題を解く時間や正解率を計測するサービスで次のような特徴があります",
      feature_items: [
        "間違えた問題だけの復習が簡単",
        "復習問題のリストが固定URLに入っている(のでブックマークしていれば再開が簡単)",
        "開始と終了のタイミングで状態をブラウザに保存しているので(ブックマークしてなくても)再開が簡単",
      ],
    },
    {
      display_p: false,
      link_path: [:tb],
      icon: "shuriken",
      title: "将棋トレーニングバトル",
      image_source: nil,
      description: "詰将棋力を競う対戦ゲームで次のような特徴があります",
      feature_items: [
      ],
    },
    # / = link_path(icon_tag(:shuriken) + "トレーニングバトル", :tb, class: ["navbar-item", ("is-active" if params[:controller] == "scripts" && params[:id] == "actb_app")]) if Actb::Config[:main_navbar_enable]
  ]
end
