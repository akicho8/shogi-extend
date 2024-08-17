require "./setup"
Swars::ZipDlLog.destroy_all
User.admin.swars_zip_dl_logs.destroy_all
instance = QuickScript::Swars::BattleDownloadScript.new({query: "bsplive 勝敗:勝ち", scope_key: "recent", max_key: "1"}, {current_user: User.admin, background_mode: true})
instance.dl_rest_count          # => 1
instance.call                   # => #<Mail::Message:23520, Multipart: true, Headers: <Date: Sat, 17 Aug 2024 14:33:39 +0900>, <From: SHOGI-EXTEND <shogi.extend@gmail.com>>, <To: shogi.extend@gmail.com>, <Bcc: shogi.extend@gmail.com>, <Message-ID: <66c03633ef6c7_1799216bc291af@ikemac2023.local.mail>>, <Subject: [development] bsplive 八段の将棋ウォーズ棋譜ダウンロード(直近1件)>, <Mime-Version: 1.0>, <Content-Type: multipart/mixed; charset=UTF-8; boundary="--==_mimepart_66c03633ef1fd_1799216bc290b5">, <Content-Transfer-Encoding: 7bit>>
instance.download_content.size  # => 1728
instance.download_filename      # => "shogiwars-bsplive-1-20240612192106-kif-UTF-8.zip"
instance.dl_rest_count          # => 1
puts instance.summary
# >> 2024-08-17T05:33:39.880Z pid=96658 tid=20j2 INFO: Sidekiq 7.1.6 connecting to Redis with options {:size=>10, :pool_name=>"internal", :url=>"redis://localhost:6379/4"}
# >> |----------------------------------+--------------------------------------------------|
# >> |               ログインユーザー名 | 運営                                             |
# >> |     検索クエリ(ウォーズIDを含む) | bsplive 勝敗:勝ち                                |
# >> | クエリから抽出した対象ウォーズID | bsplive                                          |
# >> |                         対局総数 | 5017                                             |
# >> |                 指定したスコープ | 直近                                             |
# >> |                     指定した件数 | 1                                                |
# >> |               実際に取得した件数 | 1                                                |
# >> |                       文字コード | UTF-8                                            |
# >> |                       ファイル名 | shogiwars-bsplive-1-20240612192106-kif-UTF-8.zip |
# >> |                         処理時間 | 0.28s                                            |
# >> |     今回を除くをダウンロード総数 | 1                                                |
# >> |----------------------------------+--------------------------------------------------|
