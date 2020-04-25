AppConfig.deep_merge!({
    :app_name                                =>  "SHOGI-EXTEND",
    :volume                                  =>  0.5,
    :admin_email                             =>  "alice@localhost",

    :free_battles_import                     =>  false, # 野良棋譜のセットアップ時に保持している対局を取り込むか？
    :colosseum_battle_enable                 =>  true,  # ネット対戦機能
    :player_info_function                    =>  true,  # プレイヤー情報
    :more_import_function                    =>  true,  # もっと取り込む
    :swars_tag_search_function               =>  true,  # タグ検索
    :battle_index_permalink_show             =>  true,  # 固定リンクを表示するか？
    :search_form_datalist_function           =>  false, # 検索で入力したユーザー名を共有して検索候補にするか？
    :swars_tweet_function                    =>  true,  # 将棋ウォーズ棋譜詳細へのツイートできる？
    :kento_enable                            =>  true,  # KENTO にリンクする？
    :xy_master_custom_mode                     =>  false, # 符号の鬼の設定機能を有効にする？
    :help_function                           =>  false, # 使い方の表示
    :columns_detail_show                     =>  true,  # 「開戦」の手数を表示する？
    :free_battles_pro_mode                   =>  false, # 野良棋譜にいろいろ入れる？
    :force_convert_for_twitter_image         =>  false, # 作成した画像を強制的に 1600x630 に変更する
    :html2canvas_enable                      =>  false, # html2canvas を使って盤面を取り込む機能を入れる？
    :kento_params_use_kifu_param_only        =>  false, # KENTOには kifu=*.kif だけ渡す？
    :action_cable_enable                     =>  true,  # KENTOには kifu=*.kif だけ渡す？

    :zip_download_function =>  true,  # 一括ダウンロード機能
    :zip_dl_max_default    =>  30,    # 一括ダウンロードするときの件数(初期値)
    :zip_dl_max            =>  30,    # 一括ダウンロードするときの件数(最大)

    :per_page_list                           =>  [25],  # 1ページあたりの項目数選択肢リストの最初と最後を除いたもの
    :required_user_key_for_search            =>  true,  # 検索にはユーザー名を必ず指定するか？
    :required_query_for_search               =>  true,  # js側から一覧のレコードを出すときは必ず query が入っていないといけないか？

    :redis_db_for_xy_rule_info           => 2,    # 符号の鬼のランキング用
    :redis_db_for_colosseum_ranking_info => 3,    # 対戦のランキング用
    :redis_db_for_acns2                  => 4,    # acns2
  })
