require "./setup"
Swars::ZipDlLog.destroy_all
User.admin.swars_zip_dl_logs.destroy_all
instance = QuickScript::Swars::BattleDownloadScript.new({ query: "bsplive 勝敗:勝ち", scope_key: "recent", max_key: "1" }, { current_user: User.admin, running_in_background: true })
instance.dl_rest_count          # => 1
instance.call                   # => #<Mail::Message:10816, Multipart: true, Headers: <Date: Mon, 21 Jul 2025 21:34:49 +0900>, <From: SHOGI-EXTEND <shogi.extend@gmail.com>>, <To: shogi.extend@gmail.com>, <Bcc: shogi.extend@gmail.com>, <Message-ID: <687e33e9806ee_d4179f0467a7@ikemac2023.local.mail>>, <Subject: 📗[development] 【将棋ウォーズ棋譜ダウンロード】bsplive 勝敗:勝ち (直近1件)>, <Mime-Version: 1.0>, <Content-Type: multipart/mixed; charset=UTF-8; boundary="--==_mimepart_687e33e97fdd5_d4179f04669f">, <Content-Transfer-Encoding: 7bit>, <X-Rails-Environment: development>>
instance.download_content.size  # => 1812
instance.download_filename      # => "shogiwars-bsplive_勝敗_勝ち-1-20250427223112-kif-UTF-8.zip"
instance.dl_rest_count          # => 1
puts instance.summary

Swars::ZipDlLog.destroy_all
User.admin.swars_zip_dl_logs.destroy_all
instance = QuickScript::Swars::BattleDownloadScript.new({ query: "嬉野流", scope_key: "continue", max_key: "1" }, { current_user: User.admin, running_in_background: true })
instance.dl_rest_count          # => 1
instance.call                   # => #<Mail::Message:10856, Multipart: true, Headers: <Date: Mon, 21 Jul 2025 21:34:54 +0900>, <From: SHOGI-EXTEND <shogi.extend@gmail.com>>, <To: shogi.extend@gmail.com>, <Bcc: shogi.extend@gmail.com>, <Message-ID: <687e33eed756_d4179f046911@ikemac2023.local.mail>>, <Subject: 📗[development] 【将棋ウォーズ棋譜ダウンロード】嬉野流 (前回の続きから1件)>, <Mime-Version: 1.0>, <Content-Type: multipart/mixed; charset=UTF-8; boundary="--==_mimepart_687e33eed0e2_d4179f046832">, <Content-Transfer-Encoding: 7bit>, <X-Rails-Environment: development>>
instance.download_content.size  # => 2291
instance.download_filename      # => "shogiwars-嬉野流-1-20250426193710-kif-UTF-8.zip"
instance.dl_rest_count          # => 1
puts instance.summary

# >> 2025-07-21T12:34:49.448Z pid=54295 tid=17tz INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
# >> |------------------------------+------------------------------------------------------------|
# >> |           ログインユーザー名 | 運営                                                       |
# >> | 検索クエリ(ウォーズIDを含む) | bsplive 勝敗:勝ち                                          |
# >> |             指定したスコープ | 直近                                                       |
# >> |                 指定した件数 | 1                                                          |
# >> |           実際に取得した件数 | 1                                                          |
# >> |                   文字コード | UTF-8                                                      |
# >> |                   ファイル名 | shogiwars-bsplive_勝敗_勝ち-1-20250427223112-kif-UTF-8.zip |
# >> |                     処理時間 | 0.40s                                                      |
# >> |   今回を除くダウンロード総数 | 1                                                          |
# >> |------------------------------+------------------------------------------------------------|
# >> |------------------------------+-------------------------------------------------|
# >> |           ログインユーザー名 | 運営                                            |
# >> | 検索クエリ(ウォーズIDを含む) | 嬉野流                                          |
# >> |             指定したスコープ | 前回の続きから                                  |
# >> |                 指定した件数 | 1                                               |
# >> |           実際に取得した件数 | 1                                               |
# >> |                   文字コード | UTF-8                                           |
# >> |                   ファイル名 | shogiwars-嬉野流-1-20250426193710-kif-UTF-8.zip |
# >> |                     処理時間 | 0.10s                                           |
# >> |   今回を除くダウンロード総数 | 1                                               |
# >> |------------------------------+-------------------------------------------------|
