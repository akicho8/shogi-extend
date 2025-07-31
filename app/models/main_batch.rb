class MainBatch
  def call
    AppLog.important(subject: "バッチ処理 開始")
    public_send(Rails.env)
    AppLog.important(subject: "バッチ処理 終了")
  end

  def production
    # 奨励会三段リーグ
    Tsl::League.setup(verbose: false)

    # 動画変換
    Kiwi::Lemon.background_job_for_cron   # 動画変換。job時間が 0...0 ならcronで実行する

    # 将棋ウォーズ棋譜検索クロール
    if Rails.env.production?
      Swars::Crawler::ReserveUserCrawler.call    # 棋譜取得の予約者
      Swars::Crawler::MainActiveUserCrawler.call # 活動的なプレイヤー
      # Swars::Crawler::SemiActiveUserCrawler.call # 直近数日で注目されているユーザー
    end

    # 削除シリーズ
    Kiwi::Lemon.cleanup(execute: true)   # ライブラリ登録していないものを削除する(x-files以下の対応ファイルも削除する)
    XfilesCleanup.new(execute: true).call # public/system/x-files 以下の古い png と rb を削除する
    FreeBattle.cleanup(execute: true)
    MediaBuilder.old_media_file_clean(execute: true, keep: 3)

    # GeneralCleaner シリーズ
    Swars::Battle.drop_scope1.cleaner(subject: "一般", execute: true).call  # 30分かかる
    Swars::Battle.drop_scope2.cleaner(subject: "特別", execute: true).call
    Swars::SearchLog.old_only(100.days).cleaner(subject: "棋譜検索ログ", execute: true).call
    GoogleApi::ExpirationTracker.old_only(50.days).cleaner(subject: "スプレッドシート", execute: true).call
    AppLog.old_only(1.weeks).cleaner(subject: "アプリログ", execute: true).call
    ShareBoard::ChatMessage.old_only(30.days).cleaner(subject: "共有将棋盤チャット発言", execute: true).call

    # 集計 (TODO: 自動的に cache_write があるクラスを集める……のはやりすぎか)
    QuickScript::Swars::RuleWiseWinRateScript.new.cache_write  # 統計
    QuickScript::Swars::SprintWinRateScript.new.cache_write    # 棋力毎のスプリント先後勝率

    QuickScript::Swars::UserDistScript.new.cache_write         # 棋力分布
    QuickScript::Swars::HourlyActiveUserScript.new.cache_write # 時間帯別対局者情報
    QuickScript::Swars::TacticStatScript.new.cache_write       # 戦法一覧・戦法勝率ランキング
    QuickScript::Swars::GradeSegmentScript.new.cache_write     # 棋力別の情報
    QuickScript::Swars::TacticCrossScript.new.cache_write      # 将棋ウォーズ戦法人気ランキング (棋力別)

    # BattleIdMining 系
    QuickScript::Swars::TacticBattleMiningScript.new.cache_write # 戦法
    QuickScript::Swars::GradeBattleMiningScript.new.cache_write  # 棋力
    QuickScript::Swars::PresetBattleMiningScript.new.cache_write # 手合
    QuickScript::Swars::StyleBattleMiningScript.new.cache_write  # スタイル

    # チェック
    Swars::SystemValidator.new.call
  end

  def staging
    production
  end
end
