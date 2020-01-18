AppConfig.deep_merge!({
    app_name: "将棋のツール（仮）",
    volume: 0.2,
    admin_email: "alice@localhost",

    free_battles_import: false,
    colosseum_battle_enable: true,   # ネット対戦機能
    player_info_function: true,      # プレイヤー情報
    more_import_function: true,      # もっと取り込む
    swars_tag_search_function: true, # タグ検索
    battle_index_permalink_show: true,            # 固定リンクを表示するか？
    swars_side_tweet_copy_function: true,

    zip_download_function: true,     # 一括ダウンロード機能
    zip_download_limit_default: 100, # 一括ダウンロードするときの件数(初期値)
    zip_download_limit_max: 200,     # 一括ダウンロードするときの件数(最大)

    per_page_list: [25, 50],                       # 1ページあたりの項目数選択肢リストの最初と最後を除いたもの
    required_user_key_for_search: true,            # 検索にはユーザー名を必ず指定するか？
    required_query_for_search: true,               # js側から一覧のレコードを出すときは必ず query が入っていないといけないか？
    swars_battles_index_filter_options_show: true, # 将棋ウォーズ棋譜検索のフィルターオプションを表示する？
  })
