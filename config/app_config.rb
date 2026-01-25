AppConfig.deep_merge!({
    :app_name                       => "SHOGI-EXTEND",
    :my_request_origin              => "http://localhost:4000",

    :zip_dl_max_default             => 50, # 一括ダウンロードするときの件数(初期値)
    :zip_dl_max_of_max              => 50, # 一括ダウンロードするときの件数(最大)

    :share_board_api_version        => 117, # CLIENT_SIDE_API_VERSION

    ################################################################################ email
    :admin_email_name               => "SHOGI-EXTEND",
    :admin_email                    => "shogi.extend@gmail.com",
    :bot_email                      => "shogi.extend+bot@gmail.com",

    ################################################################################ login
    :available_providers            =>  [:twitter, :google, :github], # SNS経由ログインできるもの
    :nanasi_login                   =>  true,                         # 名無しログインの有効化
    :email_pw_login                 =>  true,                         # ID/PWログイン機能
    :email_direct_set               =>  false,                        # email変更はメールで確認せずすぐに設定する(危険)

    ################################################################################ redis
    :redis_db_for_rails_cache       => 1,    # Rails.cache
    :redis_db_for_xy_master         => 2,    # 符号の鬼のランキング用
    :redis_db_for_exclusive_access  => 3,    # ExclusiveAccess
    :redis_db_for_sidekiq           => 4,    # sidekiq
    :redis_db_for_actioncable       => 5,    # ActionCable
    :redis_db_for_share_board_room  => 6,    # 共有将棋盤ROOM
    :redis_db_for_share_board_ai    => 7,    # 共有将棋盤ChatGPT
    :redis_db_for_share_board_lobby => 8,    # 共有将棋盤ロビー

    ################################################################################ 他
    :ai_active             => true,  # ChatGPT を有効にするか？
    :encyclopedia_link              => true,  # 判定局面を公開するか？ → する
  })
