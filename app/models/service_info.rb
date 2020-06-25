class ServiceInfo
  include ApplicationMemoryRecord
  memory_record [
    {
      display_p: true,
      link_path: [:swars, :battles],
      title: "将棋ウォーズ棋譜検索",
      image_source: "swars_battles_index.png",
      description: "直近の対局の検討することを目的とした棋譜取得サービスです",
      feature_items: [
        "「ぴよ将棋」や「KENTO」とのスムーズな連携",
        "「激指」などに棋譜を転送するためのクリップボード機能",
        "対段級位毎や戦法毎の勝率表示",
        "プロ棋戦風の棋譜印刷",
        "消費時間の可視化",
        "指定局面の画像化やツイート",
      ],
    },
    {
      display_p: true,
      link_path: [:adapter],
      title: "なんでも棋譜変換",
      image_source: "adapter.png",
      description: "互換性が低い棋譜形式を一般的な形式に変換してどのソフトでも読めるようにするサービスです",
      feature_items: [
        "「将棋倶楽部24」の変則的な棋譜を正規化",
        "「将棋クエスト」のCSA形式を一般的な形式に変換",
        "KIF・KI2・SFEN・BOD 形式の相互変換",
        "「KENTO」や「将棋DB2」のURLから棋譜を復元",
        "「ぴよ将棋」や「KENTO」に橋渡し",
        "棋譜をネットで公開する(ツイート機能あり)",
        "特定局面の画像化",
      ],
    },
    {
      display_p: true,
      link_path: [:share_board],
      title: "共有将棋盤",
      image_source: "share_board_1200x630.png",
      description: "リレー将棋・詰将棋の出題・課題局面の検討などを目的とした将棋盤の共有サービスです",
      feature_items: [
        "課題局面や詰将棋の作成ができる",
        "URLをTwitter等のSNSに貼ると局面画像が現れる",
        "URLから訪れた人は指し継げる (駒を動かしながら詰将棋が解ける)",
        "棋譜や視点の情報はすべてURLに含まれている",
        "そのため分岐しても前の状態に影響を与えない",
      ],
    },
    {
      display_p: true,
      link_path: [:xy_records],
      title: "符号の鬼",
      image_source: "xy_records_1200x630.png",
      description: "符号を覚えるためのミニゲームです",
      feature_items: [
        "画面をタップするスマホ用とキーボードで入力するPC用の2つのモード",
        "100問正解するまでの時間を競う",
        "先後両方の視点で練習可",
        "ランキングあり",
        "やっているときはおもしろいのに急に冷める",
      ],
    },
    {
      display_p: true,
      link_path: FrontendScript::ThreeStageLeagueScript.script_link_path,
      title: "三段リーグ成績早見表",
      image_source: "three_stage_leage_1200x630.png",
      description: "奨励会三段リーグの成績を見やすくするサービスです",
      feature_items: [
        "スマホに最適化",
        "個人毎の成績も表示",
      ],
    },
    {
      display_p: true,
      link_path: [:stopwatch],
      title: "詰将棋RTA向けストップウォッチ",
      image_source: "stopwatch_1200x630.png",
      description: "詰将棋などの問題を解く時間や正解率を計測するサービスです",
      feature_items: [
        "間違えた問題だけの復習が簡単",
        "復習問題のリストが固定URLに入っている(のでブックマークしていれば再開が簡単)",
        "開始と終了のタイミングで状態をブラウザに保存しているので(ブックマークしてなくても)再開が簡単",
      ],
    },
    {
      display_p: false,
      link_path: [:training],
      title: "将棋トレーニングバトル",
      image_source: nil,
      description: "対局ではなく問題を解く力を競う対戦ゲームです",
      feature_items: [
      ],
    },
    {
      display_p: true,
      link_path: [:cpu_battles],
      title: "CPU対戦",
      image_source: "cpu_battle_1200x630.png",
      description: "自作の将棋AIと対戦。CPUは矢倉・右四間飛車・嬉野流・アヒル戦法・振り飛車・英春流かまいたち戦法を指せます",
    },
  ]
end
