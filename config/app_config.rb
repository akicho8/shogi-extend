AppConfig.deep_merge!({
    :app_name                            =>  "SHOGI-EXTEND",
    :volume                              =>  0.5,

    :swars_tag_search_function           =>  true,  # タグ検索
    :columns_detail_show                 =>  true,  # 「開戦」の手数を表示する？

    :zip_dl_size                         =>  30,    # 一括ダウンロードするときの件数(初期値)
    :zip_dl_max                          =>  30,    # 一括ダウンロードするときの件数(最大)

    :per_page_list                       =>  [25],  # 1ページあたりの項目数選択肢リストの最初と最後を除いたもの

    ################################################################################ email
    :admin_email_name                    =>  "SHOGI-EXTEND 運営",
    :admin_email                         =>  "shogi.extend@gmail.com",
    :bot_email                           =>  "shogi.extend+bot@gmail.com",

    ################################################################################ redis
    :redis_db_for_xy_rule_info           => 2,    # 符号の鬼のランキング用
    :redis_db_for_colosseum_ranking_info => 3,    # 対戦のランキング用
    :redis_db_for_actb                   => 4,    # actb
    :redis_db_for_sidekiq                => 5,    # sidekiq

    ################################################################################ login
    :available_providers                 =>  [:twitter, :google, :github], # SNS経由ログインできるもの
    :nanasi_login                        =>  true,                         # 名無しログインの有効化
    :email_pw_login                      =>  true,                         # ID/PWログイン機能
  })
