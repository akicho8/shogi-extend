AppConfig.deep_merge!({
    :app_name                            => "SHOGI-EXTEND",
    :my_request_origin                       => "http://localhost:4000",

    :zip_dl_max_default                  =>  50,    # 一括ダウンロードするときの件数(初期値)
    :zip_dl_max_of_max                   =>  50,    # 一括ダウンロードするときの件数(最大)

    ################################################################################ email
    :admin_email_name                    =>  "SHOGI-EXTEND",
    :admin_email                         =>  "shogi.extend@gmail.com",
    :bot_email                           =>  "shogi.extend+bot@gmail.com",

    ################################################################################ redis
    :redis_db_for_xy_master         => 2,    # 符号の鬼のランキング用
    :redis_db_for_exclusive_access        => 3,    # ExclusiveAccess
    :redis_db_for_sidekiq           => 5,    # sidekiq
    :redis_db_for_share_board_chat  => 7,    # 共有将棋盤チャット
    :redis_db_for_share_board_lobby => 8,    # 共有将棋盤ロビー

    ################################################################################ login
    :available_providers                 =>  [:twitter, :google, :github], # SNS経由ログインできるもの
    :nanasi_login                        =>  true,                         # 名無しログインの有効化
    :email_pw_login                      =>  true,                         # ID/PWログイン機能
    :email_direct_set                    =>  false,                        # email変更はメールで確認せずすぐに設定する(危険)
  })
