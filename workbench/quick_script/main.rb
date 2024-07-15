require "./setup"
QuickScript::Main.dispatch(qs_group_key: "dev", qs_page_key: "foo-bar-baz") # => #<QuickScript::Dev::FooBarBazScript:0x000000010c8fe460 @params={:qs_group_key=>"dev", :qs_page_key=>"foo_bar_baz"}, @options={}>
QuickScript::Main.dispatch(qs_group_key: "dev", qs_page_key: "foo_bar_baz") # => #<QuickScript::Dev::FooBarBazScript:0x000000010cc7e2e8 @params={:qs_group_key=>"dev", :qs_page_key=>"foo_bar_baz"}, @options={}>
tp QuickScript::Main.info

# >> |---------------------------------------------+---------------------------+---------+------------------------------------+------------------------------------------------------------------------------------------------------|
# >> | model                                       | qs_key                    | OGP画像 | title                              | description                                                                                          |
# >> |---------------------------------------------+---------------------------+---------+------------------------------------+------------------------------------------------------------------------------------------------------|
# >> | QuickScript::Swars::ProScript               | swars/pro                 |         | プロの棋力                         | プロ棋士のウォーズの段位をまとめて表示する                                                           |
# >> | QuickScript::Swars::UserScript              | swars/user                |         | 将棋ウォーズ棋力一覧               | 指定ユーザー毎の棋力をまとめて表示する (SNSグループのメンバー全員の棋力を把握したいときなどにどうぞ) |
# >> | QuickScript::Swars::PrisonNewScript         | swars/prison_new          |         | 将棋ウォーズ囚人登録               | 指定ユーザーを囚人とする                                                                             |
# >> | QuickScript::Swars::PrisonAllScript         | swars/prison_all          |         | 将棋ウォーズ囚人一覧               | すべてのユーザーをアルファベット順で表示する                                                         |
# >> | QuickScript::Swars::PrisonSearchScript      | swars/prison_search       |         | 将棋ウォーズ囚人検索               | 検察結果を収監発見日の直近順に表示する                                                               |
# >> | QuickScript::Group1::HelloScript            | group1/hello              |         | こんにちは表示                     | こんにちはと表示する                                                                                 |
# >> | QuickScript::Dev::ValueScript               | dev/value                 |         | 値の表示                           | すべての表示形式のテスト                                                                             |
# >> | QuickScript::Dev::TableScript               | dev/table                 |         | テーブル表示                       | ハッシュの配列を返したときの表示を行う                                                               |
# >> | QuickScript::Dev::SleepScript               | dev/sleep                 |         | 1秒待つ                            | レスポンスに必ず1秒かかる。ただしローディングエフェクトにより連打できない。                          |
# >> | QuickScript::Dev::SheetScript               | dev/sheet                 |         | Google シート出力                  | テーブルを Google スプレッドシートで出力する                                                         |
# >> | QuickScript::Dev::SessionScript             | dev/session               |         | セッションID                       | session.id.to_s                                                                                      |
# >> | QuickScript::Dev::SessionCounterScript      | dev/session_counter       |         | セッションカウンタ                 | Redis を使って内部で連打を防止する                                                                   |
# >> | QuickScript::Dev::Redirect2Script           | dev/redirect2             |         | リダイレクト2 (外部)               | 外部サイトにリダイレクトする                                                                         |
# >> | QuickScript::Dev::Redirect1Script           | dev/redirect1             |         | リダイレクト1 (内部)               | $router.push で移動する                                                                              |
# >> | QuickScript::Dev::PostAndRedirectScript     | dev/post_and_redirect     |         | POSTしてリダイレクト               | flash[:notice] 付き                                                                                  |
# >> | QuickScript::Dev::Post3SessionCounterScript | dev/post3_session_counter |         | POST実行3                          | POSTボタンで送信したときだけセッションカウンタを更新する                                             |
# >> | QuickScript::Dev::Post2FormCounterScript    | dev/post2_form_counter    |         | POST実行2                          | POST で送信したときだけフォームのカウンタを更新する                                                  |
# >> | QuickScript::Dev::Post1Script               | dev/post1                 |         | POST実行1                          | サーバー側で POST or GET を判別する                                                                  |
# >> | QuickScript::Dev::NullScript                | dev/null                  |         | 何もしない                         | 本当に何もしない                                                                                     |
# >> | QuickScript::Dev::NavibarFalseScript        | dev/navibar_false         |         | navbarなし                         | navibar_show = false にしてある                                                                      |
# >> | QuickScript::Dev::LoginRequired2Script      | dev/login_required2       |         | ログインモーダル発動2              | 読み込みが終わったタイミングで nuxt_login_required を実行する                                        |
# >> | QuickScript::Dev::LoginRequired1Script      | dev/login_required1       |         | ログインモーダル発動1              | ボタンを押したタイミングでログインモーダルを発動してログインしていないと先に進ませない               |
# >> | QuickScript::Dev::InvisibleScript           | dev/invisible             |         | 非表示                             | 見えてはいけないスクリプト                                                                           |
# >> | QuickScript::Dev::HtmlScript                | dev/html                  |         | HTML表示                           | タグで始まると HTML として表示する                                                                   |
# >> | QuickScript::Dev::HelloScript               | dev/hello                 |         | こんにちは表示                     | こんにちはと表示する                                                                                 |
# >> | QuickScript::Dev::FormScript                | dev/form                  |         | form                               | form_parts のテスト                                                                                  |
# >> | QuickScript::Dev::FlashScript               | dev/flash                 |         | flash                              | 本文には含めない一時的なメッセージを表示する                                                         |
# >> | QuickScript::Dev::FetchIndexScript          | dev/fetch_index           |         | 重い生成処理対策                   | 特殊な重い処理を実行するパラメータをURLの付与しないようにして直リンクから実行を防ぐ仕組みを検証する  |
# >> | QuickScript::Dev::ErrorScript               | dev/error                 |         | 例外表示                           | バックトレース付きで表示する                                                                         |
# >> | QuickScript::Dev::DownloadPostScript        | dev/download_post         |         | CSVダウンロード(POST)              | CSVダウンロードを行う                                                                                |
# >> | QuickScript::Dev::DownloadGetScript         | dev/download_get          |         | CSVダウンロード(GET)               | CSVダウンロードを行う                                                                                |
# >> | QuickScript::Dev::CalcScript                | dev/calc                  |         | 計算機                             | 足し算を行う                                                                                         |
# >> | QuickScript::Chore::NullScript              | chore/null                | ○      | 何もしない                         | 本当に何もしない                                                                                     |
# >> | QuickScript::Chore::NotFoundScript          | chore/not_found           |         | Not Found                          | ページが見つかりません                                                                               |
# >> | QuickScript::Chore::MessageScript           | chore/message             |         | メッセージ表示                     | 引数のメッセージを表示する                                                                           |
# >> | QuickScript::Chore::InvisibleScript         | chore/invisible           |         | 非表示                             | 見えてはいけないスクリプト                                                                           |
# >> | QuickScript::Chore::IndexScript             | chore/index               |         | Index                              | スクリプト一覧を表示する                                                                             |
# >> | QuickScript::Chore::GroupScript             | chore/group               |         | 簡易ツールのグループ一覧           | グループ一覧を表示する                                                                               |
# >> | QuickScript::Admin::SwarsAgentScript        | admin/swars_agent         |         | 指定のウォーズIDのマイページの情報 |                                                                                                      |
# >> | QuickScript::Admin::LoginScript             | admin/login               |         | ログイン状態の確認                 |                                                                                                      |
# >> | QuickScript::Dev::FooBarBazScript           | dev/foo_bar_baz           |         | スクリプト名のテスト               | スクリプト名にハイフンを含むため URL では foo-bar-baz となるのが正しい                               |
# >> |---------------------------------------------+---------------------------+---------+------------------------------------+------------------------------------------------------------------------------------------------------|
