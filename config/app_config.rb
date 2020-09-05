AppConfig.deep_merge!({
    :app_name                                =>  "SHOGI-EXTEND",
    :volume                                  =>  0.5,

    :free_battles_import                     =>  false, # 野良棋譜のセットアップ時に保持している対局を取り込むか？
    :player_info_function                    =>  true,  # プレイヤー情報
    :more_import_function                    =>  true,  # もっと取り込む
    :swars_tag_search_function               =>  true,  # タグ検索
    :battle_index_permalink_show             =>  true,  # 固定リンクを表示するか？
    :search_form_datalist_function           =>  false, # 検索で入力したユーザー名を共有して検索候補にするか？
    :swars_tweet_function                    =>  true,  # 将棋ウォーズ棋譜詳細へのツイートできる？
    :columns_detail_show                     =>  true,  # 「開戦」の手数を表示する？
    :free_battles_pro_mode                   =>  false, # 野良棋譜にいろいろ入れる？
    :force_convert_for_twitter_image         =>  false, # 作成した画像を強制的に 1600x630 に変更する

    :zip_dl_max_default    =>  30,    # 一括ダウンロードするときの件数(初期値)
    :zip_dl_max            =>  30,    # 一括ダウンロードするときの件数(最大)

    :per_page_list                           =>  [25],  # 1ページあたりの項目数選択肢リストの最初と最後を除いたもの
    :required_user_key_for_search            =>  true,  # 検索にはユーザー名を必ず指定するか？
    :required_query_for_search               =>  true,  # js側から一覧のレコードを出すときは必ず query が入っていないといけないか？

    ################################################################################ email
    :admin_email_name =>  "SHOGI-EXTEND 運営",
    :admin_email      =>  "shogi.extend@gmail.com",
    :bot_email        =>  "shogi.extend+bot@gmail.com",

    ################################################################################ redis
    :redis_db_for_xy_rule_info           => 2,    # 符号の鬼のランキング用
    :redis_db_for_colosseum_ranking_info => 3,    # 対戦のランキング用
    :redis_db_for_actb                   => 4,    # actb
    :redis_db_for_sidekiq                => 5,    # sidekiq

    ################################################################################ login
    :available_providers =>  [:twitter, :google, :github], # SNS経由ログインできるもの
    :nanasi_login        =>  true,                         # 名無しログインの有効化
    :email_pw_login         =>  true,                         # ID/PWログイン機能
  })
